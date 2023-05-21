function bbcf
    if [ -e $HOME/Brewfile ]
        echo "-> Running bundle cleanup (force) for Brewfile located at $HOME/Brewfile"
        sleep 2
        brew bundle cleanup --force --file $HOME/Brewfile
    else
        echo "Brewfile not found."
    end
end
