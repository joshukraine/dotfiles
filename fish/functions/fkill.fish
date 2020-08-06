function fkill -d "Fuzzy kill"
    set pid (ps -ef | sed 1d | fzf -m | awk '{print $2}')

    if test -n "$pid"
        echo $pid | xargs kill -9
    end
end
