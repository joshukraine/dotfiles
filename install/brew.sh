#!/bin/sh

# Update Homebrew, formulae, and packages

brew update
brew upgrade

# Install GNU packages (and override OSX version)

apps=(
    ansible
    bash-completion
    coreutils
    dockutil
    ffmpeg
    gnu-sed --default-names
    htop-osx
    imagemagick
    nmap
    python
    ssh-copy-id
    tree
    wget
)

brew install ${apps[@]}
