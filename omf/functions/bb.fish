function bb
    set machine (scutil --get HostName)

    if [ -d $DOTFILES/machines/$machine ]
        set brewfile_path $DOTFILES/machines/$machine/Brewfile
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
