#!/bin/sh

################################################################################
# setup.sh
#
# This script is intended to set up a new Mac computer with my dotfiles and
# other development preferences.
################################################################################


set -e # Terminate script if anything exits with a non-zero value
set -u # Prevent unset variables

fancy_echo() { # Thank you, thoughtbot. :)
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

################################################################################
# Set some variables
################################################################################

osname=$(uname)
divider="====>"
COMMANDLINE_TOOLS="/Library/Developer/CommandLineTools"
DOTFILES_DIR=$HOME/dotfiles

################################################################################
# Check for presence of command line tools if OS X
################################################################################

if [[ "$osname" == 'Darwin' && ! -d "$COMMANDLINE_TOOLS" ]]; then
  fancy_echo "Apple's command line developer tools must be installed before running this script. To install them, just run 'gcc' from the terminal and then follow the prompts. Once the command line tools have been installed, you can try running this script again."
  exit 1
fi

################################################################################
# Install oh-my-zsh
################################################################################

fancy_echo "$divider Step 1: Installing oh-my-zsh..."

curl -L http://install.ohmyz.sh | sh

################################################################################
# Provision with Laptop if OS X
################################################################################

fancy_echo "$divider Step 2: Invoking Laptop script from thoughtbot..."

if [ "$osname" == 'Darwin' ]; then
  fancy_echo "Yay, we're on a Mac!"
  curl --remote-name https://raw.githubusercontent.com/thoughtbot/laptop/master/mac
  sh mac 2>&1 | tee ~/laptop.log
elif [ "$osname" == 'Linux' ]; then
  fancy_echo "OK, we're on Linux, which is not supported by Laptop. Skipping..."
fi

################################################################################
# Setup basic directories
################################################################################

fancy_echo "$divider Step 3: Creating a few basic directories..."

mkdir -p $HOME/code
mkdir -p $HOME/Developer/training
mkdir -p $HOME/Developer/vms
mkdir -p $HOME/Developer/cheatsheets
mkdir -p $HOME/Developer/other_code
mkdir -p $HOME/src

################################################################################
# Setup dotfiles
################################################################################

fancy_echo "$divider Step 4: Installing dotfiles..."

cd $HOME
if [ ! -d $DOTFILES_DIR ]; then
  git clone https://github.com/joshukraine/dotfiles.git $DOTFILES_DIR
else
  cd $DOTFILES_DIR
  git pull origin master
fi
fancy_echo "Starting dotfiles setup script..."
source "$DOTFILES_DIR/install/symlink_dotfiles.sh"
fancy_echo "Dotfiles setup complete! Resuming main setup script..."

################################################################################
# Install Powerline-patched fonts
################################################################################

fancy_echo "$divider Step 5: Installing fixed-width fonts patched for use with Powerline symbols..."
if [ -d "$HOME/src/fonts" ]; then
  mv $HOME/src/fonts $HOME/src/fonts_backup
fi
git clone https://github.com/powerline/fonts.git $HOME/src/fonts
cd $HOME/src/fonts
./install.sh
cd $HOME
rm -rf $HOME/src/fonts
fancy_echo "Done!"

################################################################################
# Configure git
################################################################################

fancy_echo "$divider Step 6: Configuring git..."
source "$DOTFILES_DIR/install/git-setup.sh"
fancy_echo "Done!"

################################################################################
# Install Vundle and vim plugins
################################################################################

fancy_echo "$divider Step 7: Installing Vundle and vim plugins..."
source "$DOTFILES_DIR/install/vundle.sh"
fancy_echo "Done!"

################################################################################
# Install extra Homebrew packages
################################################################################

fancy_echo "$divider Step 8: Installing extra Homebrew formulae..."
source "$DOTFILES_DIR/install/brew.sh"
fancy_echo "Done!"

################################################################################
# Install Cask and related software
################################################################################

fancy_echo "$divider Step 9: Installing Cask and related software..."
brew install caskroom/cask/brew-cask
source "$DOTFILES_DIR/install/brew-cask.sh"
fancy_echo "Done!"

################################################################################
# Set OS X preferences
################################################################################

if [ "$osname" == 'Darwin' ]; then
  fancy_echo "$divider Step 10: Setting OS X preferences..."
  source "$DOTFILES_DIR/osx/defaults.sh"
  source "$DOTFILES_DIR/osx/dock.sh"
  fancy_echo "OS X prefs set successfully. Some changes may require a restart to take effect."
fi

echo ""
echo "**************************************************************"
echo "**** Setup script complete! Please restart your computer. ****"
echo "**************************************************************"
echo ""
