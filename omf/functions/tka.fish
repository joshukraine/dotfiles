# Kill all tmux sessions
function tka
  tmux ls | cut -d : -f 1 | xargs -I {} tmux kill-session -t {}
end
