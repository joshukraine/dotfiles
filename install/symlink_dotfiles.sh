#!/bin/sh

################################################################################
# symlink_dotfiles.sh
#
# This script backs up any old dotfiles on the system, and symlinks the new ones
# to their proper place in the home folder.
################################################################################

set -e # Terminate script if anything exits with a non-zero value
set -u # Prevent unset variables

################################################################################
# Initial setup
################################################################################

DOTFILES_DIR=$HOME/dotfiles
files="gemrc gitignore_global gitconfig hushlogin tmux.conf vimrc zshrc"

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

cd $HOME

################################################################################
# Symklink new dotfiles to $HOME
################################################################################

fancy_echo "Creating symlinks..."

for file in $files; do
  if [ -f $HOME/.$file ]; then
    fancy_echo ".$file already present. Backing up..."
    cp $HOME/.$file "$HOME/.${file}_backup"
    rm -f $HOME/.$file
  fi
  fancy_echo "-> Linking $DOTFILES_DIR/$file to $HOME/.$file..."
  ln -nfs "$DOTFILES_DIR/$file" "$HOME/.$file"
done

fancy_echo "-> Linking $DOTFILES_DIR/bin/tat to $HOME/.bin/tat..."
ln -nfs "$DOTFILES_DIR/bin/tat" "$HOME/.bin/tat"
