# Makes attaching to an existing tmux session (with a specific name) easier
function ta
  tmux attach -t $argv
end
