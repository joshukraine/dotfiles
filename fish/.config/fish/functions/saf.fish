# You can also toggle hidden files from the Finder GUI with Cmd + Shift + .
function saf
    defaults write com.apple.finder AppleShowAllFiles TRUE
    killall Finder
end
