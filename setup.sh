#!/bin/bash

####################################
# setup.sh
#
# This script is intended to set up a new Mac computer with my dotfiles and
# other development preferences.
####################################

set -e # Terminate script if anything exits with a non-zero value
set -u # Prevent unset variables

####################################
# Set some variables
####################################

osname=$(uname)
divider="====>"
COMMANDLINE_TOOLS="/Library/Developer/CommandLineTools"
DOTFILES_DIR=$HOME/dotfiles

####################################
# Check for presence of command line
# tools if OS X
####################################

if [[ "$osname" == 'Darwin' && ! -d "$COMMANDLINE_TOOLS" ]]; then
  echo "Apple's command line developer tools must be installed before running this script."
  echo "To install them, just run 'gcc' from the terminal and then follow the prompts."
  echo "Once the command line tools have been installed, you can try running this script again."
  exit 1
fi

####################################
# Install oh-my-zsh
####################################

echo "$divider Step 1: Installing oh-my-zsh..."
curl -L http://install.ohmyz.sh | sh

####################################
# Provision with Laptop if OS X
####################################

echo "$divider Step 2: Installing Laptop Script from thoughtbot..."
if [[ "$osname" == 'Darwin' ]]; then
  echo "Yay, we're on Mac!"
  curl --remote-name https://raw.githubusercontent.com/thoughtbot/laptop/master/mac
  sh mac 2>&1 | tee ~/laptop.log
elif [[ "$osname" == 'Linux' ]]; then
  echo "OK, we're on Linux, which is not supported by Laptop. Skipping..."
else
  echo "What the heck? You're not on Mac OR Linux?"
  echo "..."
  echo "Nathan is that you? You're so cheap. Get a Mac, dude. :P"
fi

####################################
# Setup basic directories
####################################

echo "$divider Step 3: Setting up some basic directories..."
mkdir -p $HOME/code
mkdir -p $HOME/Developer

####################################
# Setup dotfiles
####################################

echo "$divider Step 4: Installing dotfiles..."
cd $HOME

if [ ! -d $DOTFILES_DIR ]; then
  git clone https://github.com/joshukraine/dotfiles.git $DOTFILES_DIR
else
  cd $DOTFILES_DIR
  git pull origin master
fi

cd $DOTFILES_DIR
./setup_dotfiles.sh

echo "Dotfiles setup complete! Resuming main setup script..."

####################################
# Install Cask and related software
####################################

echo "$divider Step 5: Installing extra Homebrew formulae..."
brew install tree ansible htop-osx nmap ssh-copy-id tmate xz

####################################
# Install Cask and related software
####################################

echo "$divider Step 6: Installing Cask and related software..."
brew install caskroom/cask/brew-cask
brew cask install google-chrome dropbox 1password alfred iterm2

####################################
# Configure git
####################################

echo "$divider Step 7: Configuring git..."
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
git config --global core.excludesfile $HOME/.gitignore_global

####################################
# Set OS X preferences
####################################

echo "$divider Step 8: Setting OS X preferences..."

