#!/bin/sh

brew update

brew_tap 'Goles/battery'

brew_install_or_upgrade 'ansible'
brew_install_or_upgrade 'bash-completion'
brew_install_or_upgrade 'battery'
brew_install_or_upgrade 'dockutil'
brew_install_or_upgrade 'figlet'
brew_install_or_upgrade 'htop-osx'
brew_install_or_upgrade 'namebench'
brew_install_or_upgrade 'python'
brew_install_or_upgrade 'ssh-copy-id'
brew_install_or_upgrade 'tree'
brew_install_or_upgrade 'wget'
