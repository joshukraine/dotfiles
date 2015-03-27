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

echo ""
echo "Starting dotfiles setup script..."
echo ""

if [[ -d $DOTFILES ]]; then
  echo ""
  echo "Backing up old dotfiles to $HOME/old_dotfiles_backup..."
  echo ""
  rm -rf $OLD_DOTFILES_BACKUP
  cp -R $DOTFILES $OLD_DOTFILES_BACKUP
fi

####################################
# Symklink new dotfiles to $HOME
####################################

echo ""
echo "Creating symlinks..."
echo ""

for file in $files; do
  echo ""
  echo "Linking $DOTFILES/$file to $HOME/.$file..."
  echo ""
  ln -nfs "$DOTFILES/$file" "$HOME/.$file"
done

echo ""
echo "Symlinks complete!"
echo ""

####################################
# Misc tasks
####################################

echo ""
echo "Installing Vundle..."
echo ""
if [ -d $HOME/.vim/bundle ]; then
  rm -rf $HOME/.vim/bundle
fi
git clone https://github.com/gmarik/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
cp -R $DOTFILES/vim/colors $HOME/.vim # So vim won't complain about solarized not being found.
vim +PluginInstall +qall
rm -rf $HOME/.vim/colors
