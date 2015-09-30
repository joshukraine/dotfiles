#!/bin/sh

################################################################################
# setup-mac.sh
#
# This script is intended to set up a new Mac computer with my dotfiles and
# other development preferences.
################################################################################

################################################################################
# First, some helpful functions borrowed from Laptop. Thank you, thoughtbot. :)
################################################################################

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

brew_install_or_upgrade() {
  if brew_is_installed "$1"; then
    if brew_is_upgradable "$1"; then
      fancy_echo "Upgrading %s ..." "$1"
      brew upgrade "$@"
    else
      fancy_echo "Already using the latest version of %s. Skipping ..." "$1"
    fi
  else
    fancy_echo "Installing %s ..." "$1"
    brew install "$@"
  fi
}

brew_is_installed() {
  local name="$(brew_expand_alias "$1")"

  brew list -1 | grep -Fqx "$name"
}

brew_is_upgradable() {
  local name="$(brew_expand_alias "$1")"

  ! brew outdated --quiet "$name" >/dev/null
}

brew_tap() {
  brew tap "$1" 2> /dev/null
}

brew_expand_alias() {
  brew info "$1" 2>/dev/null | head -1 | awk '{gsub(/:/, ""); print $1}'
}

brew_launchctl_restart() {
  local name="$(brew_expand_alias "$1")"
  local domain="homebrew.mxcl.$name"
  local plist="$domain.plist"

  fancy_echo "Restarting %s ..." "$1"
  mkdir -p "$HOME/Library/LaunchAgents"
  ln -sfv "/usr/local/opt/$name/$plist" "$HOME/Library/LaunchAgents"

  if launchctl list | grep -Fq "$domain"; then
    launchctl unload "$HOME/Library/LaunchAgents/$plist" >/dev/null
  fi
  launchctl load "$HOME/Library/LaunchAgents/$plist" >/dev/null
}

################################################################################
# Next, a little more setup...
################################################################################

set -e # Terminate script if anything exits with a non-zero value
set -u # Prevent unset variables

osname=$(uname)
divider="====> "
COMMANDLINE_TOOLS="/Library/Developer/CommandLineTools"
DOTFILES_DIR=$HOME/dotfiles
OLD_DOTFILES_BACKUP=$HOME/old_dotfiles_backup

# Change this if you are using your own fork
DOTFILES_REPO_URL="https://github.com/joshukraine/dotfiles.git"

# Change this value for testing installs of feature branches.
DOTFILES_BRANCH="master"


################################################################################
# Make sure we're on a Mac before continuing
################################################################################

if [ "$osname" == 'Linux' ]; then
  fancy_echo "Oops, looks like you're on a Linux machine. Please run the command
below to download and execute the Linux setup script."
  fancy_echo "curl --remote-name ..."
  exit 1
elif [ "$osname" != 'Darwin' ]; then
  fancy_echo "Oops, it looks like you're using a non-UNIX system. This script
only supports Mac and Linux. Exiting..."
  exit 1
fi

################################################################################
# Check for presence of command line tools if OS X
################################################################################

if [ ! -d "$COMMANDLINE_TOOLS" ]; then
  fancy_echo "Apple's command line developer tools must be installed before
running this script. To install them, just run 'gcc' from the terminal and
then follow the prompts. Once the command line tools have been installed,
you can try running this script again."
  exit 1
fi

################################################################################
# 1. Provision with my fork of Laptop
################################################################################

fancy_echo "$divider Step 1: Invoking my fork of thoughtbot's Laptop script..."

curl --remote-name https://raw.githubusercontent.com/joshukraine/laptop/master/mac
sh mac 2>&1 | tee ~/laptop.log

################################################################################
# 2. Install oh-my-zsh
################################################################################

fancy_echo "$divider Step 2: Installing oh-my-zsh..."

if [ -d "$HOME/.oh-my-zsh" ]; then
  rm -rf $HOME/.oh-my-zsh
fi

git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

################################################################################
# 3. Setup dotfiles
################################################################################

fancy_echo "$divider Step 3: Installing dotfiles..."

if [[ -d $DOTFILES_DIR ]]; then
  fancy_echo "Backing up old dotfiles to $HOME/old_dotfiles_backup..."
  rm -rf $OLD_DOTFILES_BACKUP
  cp -R $DOTFILES_DIR $OLD_DOTFILES_BACKUP
  rm -rf $DOTFILES_DIR
fi

fancy_echo "Cloning your dotfiles repo to ${DOTFILES_DIR} ..."

cd $HOME
git clone $DOTFILES_REPO_URL -b $DOTFILES_BRANCH $DOTFILES_DIR
source "$DOTFILES_DIR/install/symlink_dotfiles.sh"

fancy_echo "Dotfiles setup complete!"

################################################################################
# 4. Install Ukrainian spell-check dictionaries
################################################################################

fancy_echo "$divider Step 4: Installing Ukrainian spell-check dictionaries..."

source "$DOTFILES_DIR/install/install_uk_dictionary.sh"

fancy_echo "Dictionaries installed!"

################################################################################
# 5. Install Powerline-patched fonts
################################################################################

fancy_echo "$divider Step 5: Installing fixed-width fonts patched for use with Powerline symbols..."

if [ -d "$HOME/src/fonts" ]; then
  rm -rf $HOME/src/fonts
fi
git clone https://github.com/powerline/fonts.git $HOME/src/fonts
cd $HOME/src/fonts
./install.sh
cd $HOME
rm -rf $HOME/src/fonts
fancy_echo "Done!"

################################################################################
# 6. Install Vundle and vim plugins
################################################################################

fancy_echo "$divider Step 6: Installing Vundle and vim plugins..."

source "$DOTFILES_DIR/install/vundle.sh"
fancy_echo "Done!"

################################################################################
# 7. Install extra Homebrew packages
################################################################################

fancy_echo "$divider Step 7: Installing extra Homebrew formulae..."

source "$DOTFILES_DIR/install/brew.sh"
fancy_echo "Done!"

################################################################################
# 8. Install Cask and related software
################################################################################

fancy_echo "$divider Step 8: Installing Cask and related software..."

brew_tap 'caskroom/cask'
brew_install_or_upgrade 'brew-cask'
source "$DOTFILES_DIR/install/brew-cask.sh"
fancy_echo "Done!"

################################################################################
# 9. Set OS X preferences
################################################################################

fancy_echo "$divider Step 9: Setting OS X preferences..."

source "$DOTFILES_DIR/osx/defaults.sh"
source "$DOTFILES_DIR/osx/dock.sh"
fancy_echo "OS X prefs set successfully. Some changes may require a restart to take effect."

echo ""
echo "**************************************************************"
echo "**** Setup script complete! Please restart your computer. ****"
echo "**************************************************************"
echo ""
