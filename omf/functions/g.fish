function g
    if count $argv >/dev/null
        git $argv
    else
        clear && git status --short --branch && echo
    end
end
