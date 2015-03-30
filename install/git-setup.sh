#!/bin/sh

################################################################################
# git-setup.sh
#
# This script sets up some basic git configuration.
################################################################################

git config --global user.name "Joshua Steele"
git config --global user.email joshukraine@gmail.com
git config --global core.editor vim
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.sta status
git config --global alias.st "status --short"
git config --global alias.df diff
git config --global alias.dfs "diff --staged"
git config --global alias.logg "log --graph --decorate --oneline --abbrev-commit --all"
