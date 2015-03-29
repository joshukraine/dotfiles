#!/bin/sh

apps=(
    1password
    alfred
    applepi-baker
    atom
    atom
    bartender
    carbon-copy-cloner
    cleanmymac
    crashplan
    doxie
    dropbox
    firefox
    google-chrome
    google-drive
    hazel
    hipchat
    istat-menus
    iterm2
    little-snitch
    namebench
    private-internet-access
    silverlight
    skype
    teamviewer
    things
    vagrant
    virtualbox
    vlc
)

brew cask install ${apps[@]} --appdir=/Applications
