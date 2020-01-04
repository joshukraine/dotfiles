function pi
    if count $argv >/dev/null
        ping -Anc 5 $argv
    else
        ping -Anc 5 1.1.1.1
    end
end
