function bbc
    if [ -d $DOTFILES/machines/$HOST_NAME ]
        set brewfile_path $DOTFILES/machines/$HOST_NAME/Brewfile
        echo "-> Running bundle cleanup dry-run for Brewfile located at $brewfile_path"
        sleep 2
        brew bundle cleanup --file $brewfile_path
    else if [ -e $HOME/Brewfile ]
        echo "-> Running bundle cleanup dry-run for Brewfile located at $HOME/Brewfile"
        sleep 2
        brew bundle cleanup --file $HOME/Brewfile
    else
        echo "Brewfile not found."
    end
end
