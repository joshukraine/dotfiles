# Create a new session named for current directory, or attach if exists.
function tna
  tmux new-session -As (basename "$PWD" | tr . -)
end
