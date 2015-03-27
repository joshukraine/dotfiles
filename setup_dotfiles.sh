#!/bin/bash

####################################
# setup_dotfiles.sh
#
# This script backs up any old
# dotfiles on the system, and
# symlinks the new ones to their
# proper place in the home folder.
####################################

set -e # Terminate script if anything exits with a non-zero value
set -u # Prevent unset variables

####################################
# Set some variables
####################################

DOTFILES=$HOME/dotfiles
OLD_DOTFILES_BACKUP=$HOME/old_dotfiles_backup
files="gemrc gitignore gitconfig tmux.conf railsrc vimrc zshrc"

####################################
# Back up old dotfiles if needed
####################################

echo "Starting dotfiles setup script..."

if [[ -d $DOTFILES ]]; then
  echo "Backing up old dotfiles to $HOME/old_dotfiles_backup..."
  rm -rf $OLD_DOTFILES_BACKUP
  cp -R $DOTFILES $OLD_DOTFILES_BACKUP
fi

####################################
# Symklink new dotfiles to $HOME
####################################

echo "Creating symlinks..."

for file in $files; do
  echo "Linking $DOTFILES/$file --> $HOME/.$file..."
  ln -nfs "$DOTFILES/$file" "$HOME/.$file"
done

echo "Symlinks complete!"

####################################
# Misc tasks
####################################

echo "Installing Vundle..."
git clone https://github.com/gmarik/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
cp -R $DOTFILES/vim/colors $HOME/.vim # So vim won't complain about solarized not being found.
vim +PluginInstall +qall

