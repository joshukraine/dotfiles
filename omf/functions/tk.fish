# Makes deleting a tmux session easier
function tk
    tmux kill-session -t $argv
end
