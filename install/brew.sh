#!/bin/sh

brew update

apps=(
    ansible
    bash-completion
    coreutils
    dockutil
    figlet
    gnu-sed --default-names
    htop-osx
    nmap
    python
    ssh-copy-id
    tree
    wget
)

brew_install_or_upgrade ${apps[@]}
