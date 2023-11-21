# You can also toggle hidden files from the Finder GUI with Cmd + Shift + .

function haf
    defaults write com.apple.finder AppleShowAllFiles FALSE
    killall Finder
end
