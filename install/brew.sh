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
    gnu-sed --default-names
    htop-osx
    nmap
    python
    ssh-copy-id
    tree
    wget
)

brew install ${apps[@]}
