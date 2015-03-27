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

echo ""
echo "$divider Step 1: Installing oh-my-zsh..."
echo ""

curl -L http://install.ohmyz.sh | sh

####################################
# Provision with Laptop if OS X
####################################

echo ""
echo "$divider Step 2: Installing Laptop Script from thoughtbot..."
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
echo "$divider Step 3: Setting up some basic directories..."
echo ""

mkdir -p $HOME/code
mkdir -p $HOME/Developer

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

cd $DOTFILES_DIR
./setup_dotfiles.sh

echo "Dotfiles setup complete! Resuming main setup script..."

####################################
# Install Cask and related software
####################################

echo ""
echo "$divider Step 5: Installing extra Homebrew formulae..."
echo ""

brew install tree ansible htop-osx nmap ssh-copy-id

####################################
# Install Cask and related software
####################################

echo ""
echo "$divider Step 6: Installing Cask and related software..."
echo ""

brew install caskroom/cask/brew-cask
brew cask install google-chrome dropbox alfred iterm2 skype vlc virtualbox little-snitch namebench vagrant cleanmymac bartender things firefox google-drive hipchat crashplan teamviewer carbon-copy-cloner istat-menus sublime-text atom silverlight applepi-baker doxie private-internet-access

####################################
# Set OS X preferences
####################################

# echo "$divider Step 7: Setting OS X preferences..."
# TODO: Set OS X prefs here.

echo ""
echo "Setup complete! Please restart your terminal."
