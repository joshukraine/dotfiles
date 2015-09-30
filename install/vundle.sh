#!/usr/bin/env bash

################################################################################
# vundle.sh
#
# This script installs Vundle.
################################################################################

if [ -d $HOME/.vim/bundle ]; then
  rm -rf $HOME/.vim/bundle
fi
git clone https://github.com/gmarik/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
cp -R $DOTFILES_DIR/vim/colors $HOME/.vim # So vim won't complain about solarized not being found.
vim +PluginInstall +qall
rm -rf $HOME/.vim/colors
