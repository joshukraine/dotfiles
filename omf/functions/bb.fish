function bb
    if [ -d $DOTFILES/machines/$HOST_NAME ]
        set brewfile_path $DOTFILES/machines/$HOST_NAME/Brewfile
        echo "-> Bundling Brewfile located at $brewfile_path"
        sleep 2
        brew bundle --file $brewfile_path
    else if [ -e $HOME/Brewfile ]
        echo "-> Bundling Brewfile located at $HOME/Brewfile"
        sleep 2
        brew bundle --no-lock --file $HOME/Brewfile
    else
        echo "Brewfile not found."
    end
end
