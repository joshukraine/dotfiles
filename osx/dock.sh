#!/bin/sh

echo ""
echo "Customizing the Dock..."
echo ""

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/Launchpad.app"
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/Applications/Mail.app"
dockutil --no-restart --add "/Applications/Calendar.app"
dockutil --no-restart --add "/Applications/Messages.app"
dockutil --no-restart --add "/Applications/Skype.app"
dockutil --no-restart --add "/Applications/Things.app"
dockutil --no-restart --add "/Applications/1Password.app"
dockutil --no-restart --add "/Applications/iTunes.app"
dockutil --no-restart --add "/Applications/App Store.app"
dockutil --no-restart --add "/Applications/iTerm.app"
dockutil --no-restart --add "/Applications/Dash.app"
dockutil --no-restart --add "/Applications/System Preferences.app"

killall Dock

echo ""
echo "Dock customization complete!"
echo ""

