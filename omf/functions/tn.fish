# Makes creating a new tmux session (with a specific name) easier
function tn
    tmux new -s $argv
end
