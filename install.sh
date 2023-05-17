#!/usr/bin/env bash

################################################################################
# install
#
# This script uses GNU Stow to symlink files and directories into place.
################################################################################

dotfiles_echo() {
    local fmt="$1"; shift

    # shellcheck disable=SC2059
    printf "\\n[DOTFILES] ${fmt}\\n" "$@"
}

if ! command -v stow >/dev/null; then
    dotfiles_echo "GNU Stow is required but was not found. Try:"
    dotfiles_echo "brew install stow"
    dotfiles_echo "Exiting..."
    exit 1
fi

sudo -v

set -e # Terminate script if anything exits with a non-zero value

dotfiles_echo "Installing dotfiles..."

if [ -z "$DOTFILES" ]; then
    export DOTFILES="${HOME}/dotfiles"
fi

dotfiles_echo "Setting HostName..."

COMPUTER_NAME=$(scutil --get ComputerName)
LOCAL_HOST_NAME=$(scutil --get LocalHostName)

sudo scutil --set HostName "$LOCAL_HOST_NAME"
HOST_NAME=$(scutil --get HostName)

sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server.plist NetBIOSName -string "$HOST_NAME"
export HOST_NAME

printf "ComputerName:  ==> [%s]\\n" "$COMPUTER_NAME"
printf "LocalHostName: ==> [%s]\\n" "$LOCAL_HOST_NAME"
printf "HostName:      ==> [%s]\\n" "$HOST_NAME"

if [ -z "$XDG_CONFIG_HOME" ]; then
    dotfiles_echo "Setting up ~/.config directory..."
    if [ ! -d "${HOME}/.config" ]; then
        mkdir "${HOME}/.config"
    fi
    export XDG_CONFIG_HOME="${HOME}/.config"
fi

dotfiles_echo "Checking your system architecture..."

osname=$(uname)

if [ "$osname" != "Darwin" ]; then
    bootstrap_echo "Oops, it looks like you're using a non-Apple system. Sorry, this script
    only supports macOS. Exiting..."
    exit 1
fi

arch="$(uname -m)"

if [ "$arch" == "arm64" ]; then
    dotfiles_echo "You're on Apple Silicon! Setting HOMEBREW_PREFIX to /opt/homebrew..."
    HOMEBREW_PREFIX="/opt/homebrew"
else
    dotfiles_echo "You're on an Intel Mac! Setting HOMEBREW_PREFIX to /usr/local..."
    HOMEBREW_PREFIX="/usr/local"
fi

dotfiles_echo "-> Setting up symlinks with GNU Stow..."

cd "$DOTFILES"/ # stow needs to run from inside dotfiles dir

for item in *; do
    if [ -d "$item" ]; then
        stow "$item"/
    fi
done

if command -v fish >/dev/null; then
    dotfiles_echo "-> Initializing fish_user_paths..."
    command fish -c "set -U fish_user_paths $HOME/.asdf/shims $HOME/.local/bin $HOME/.bin $HOME/.yarn/bin $HOMEBREW_PREFIX/bin"
fi

dotfiles_echo "-> Installing custom terminfo entries..."
tic -x "${DOTFILES}/terminfo/tmux-256color.terminfo"
tic -x "${DOTFILES}/terminfo/xterm-256color-italic.terminfo"
sudo tic -xe alacritty,alacritty-direct "${DOTFILES}/terminfo/alacritty.info"

dotfiles_echo "Dotfiles installation complete!"
