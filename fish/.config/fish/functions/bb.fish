function bb
    if [ -e $HOME/Brewfile ]
        echo "-> Bundling Brewfile located at $HOME/Brewfile"
        sleep 2
        brew bundle --file $HOME/Brewfile
    else
        echo "Brewfile not found."
    end
end
