#!/bin/sh

apps=(
    1password
    alfred
    applepi-baker
    atom
    bartender
    carbon-copy-cloner
    cleanmymac
    crashplan
    doxie
    dropbox
    fantastical
    firefox
    google-chrome
    google-drive
    hazel
    hipchat
    istat-menus
    iterm2
    little-snitch
    mactracker
    namebench
    screenflick
    silverlight
    skype
    teamviewer
    things
    vagrant
    virtualbox
    vlc
)

brew cask install ${apps[@]} --appdir=/Applications
