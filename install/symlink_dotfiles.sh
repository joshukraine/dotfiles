#!/bin/bash

################################################################################
# symlink_dotfiles.sh
#
# This script backs up any old dotfiles on the system, and symlinks the new ones
# to their proper place in the home folder.
################################################################################

set -e # Terminate script if anything exits with a non-zero value
set -u # Prevent unset variables

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

################################################################################
# Set some variables
################################################################################

DOTFILES=$HOME/dotfiles
OLD_DOTFILES_BACKUP=$HOME/old_dotfiles_backup
files="gemrc gitignore gitconfig tmux.conf railsrc vimrc zshrc"

################################################################################
# Back up old dotfiles if needed
################################################################################

if [ -d $DOTFILES ]; then
  fancy_echo "Backing up old dotfiles to $HOME/old_dotfiles_backup..."
  rm -rf $OLD_DOTFILES_BACKUP
  cp -R $DOTFILES $OLD_DOTFILES_BACKUP
fi

################################################################################
# Symklink new dotfiles to $HOME
################################################################################

fancy_echo "Creating symlinks..."
for file in $files; do
  fancy_echo "-> Linking $DOTFILES/$file to $HOME/.$file..."
  ln -nfs "$DOTFILES/$file" "$HOME/.$file"
done

