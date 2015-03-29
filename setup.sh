#!/usr/bin/env bash

####################################
# setup.sh
#
# This script is intended to set up
# a new Mac computer with my
# dotfiles and other development
# preferences.
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

echo ""
echo "$divider Step 1: Installing oh-my-zsh..."
echo ""

curl -L http://install.ohmyz.sh | sh

####################################
# Provision with Laptop if OS X
####################################

echo ""
echo "$divider Step 2: Invoking Laptop script from thoughtbot..."
echo ""

if [[ "$osname" == 'Darwin' ]]; then
  echo "Yay, we're on a Mac!"
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

echo ""
echo "$divider Step 3: Creating a few basic directories..."
echo ""

mkdir -p $HOME/code
mkdir -p $HOME/Developer
mkdir -p $HOME/Developer/training
mkdir -p $HOME/Developer/vms
mkdir -p $HOME/Developer/cheatsheets
mkdir -p $HOME/Developer/other_code
mkdir -p $HOME/src

####################################
# Setup dotfiles
####################################

echo ""
echo "$divider Step 4: Installing dotfiles..."
echo ""

cd $HOME

if [ ! -d $DOTFILES_DIR ]; then
  git clone https://github.com/joshukraine/dotfiles.git $DOTFILES_DIR
else
  cd $DOTFILES_DIR
  git pull origin master
fi

source "$DOTFILES_DIR/install/symlink_dotfiles.sh"

echo ""
echo "Dotfiles setup complete! Resuming main setup script..."
echo ""

####################################
# Install Powerline-patched fonts
####################################

echo ""
echo "$divider Step 5: Installing fixed-width fonts patched for use with Powerline symbols..."
echo ""

if [ -d "$HOME/src/fonts" ]; then
  mv $HOME/src/fonts $HOME/src/fonts_backup
fi

git clone https://github.com/powerline/fonts.git $HOME/src/fonts
cd $HOME/src/fonts
./install.sh
rm -rf $HOME/src/fonts

####################################
# Configure git
####################################

echo ""
echo "$divider Step 6: Configuring git..."
echo ""

source "$DOTFILES_DIR/install/git-setup.sh"

####################################
# Install Vundle and vim plugins
####################################

echo ""
echo "$divider Step 7: Installing Vundle and vim plugins..."
echo ""

source "$DOTFILES_DIR/install/vundle.sh"

####################################
# Install extra Homebrew packages
####################################

echo ""
echo "$divider Step 8: Installing extra Homebrew formulae..."
echo ""

source "$DOTFILES_DIR/install/brew.sh"

####################################
# Install Cask and related software
####################################

echo ""
echo "$divider Step 9: Installing Cask and related software..."
echo ""

brew install caskroom/cask/brew-cask
source "$DOTFILES_DIR/install/brew-cask.sh"

####################################
# Set OS X preferences
####################################

if [[ "$osname" == 'Darwin' ]]; then
  echo ""
  echo "$divider Step 10: Setting OS X preferences..."
  echo ""
  source "$DOTFILES_DIR/osx/defaults.sh"
  source "$DOTFILES_DIR/osx/dock.sh"
fi

echo ""
echo "Setup complete! Please restart your terminal."
