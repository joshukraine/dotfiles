# Source tmux configuration file to reload settings
#
# Usage: tsrc
# Arguments: None
#
# Examples:
#   tsrc                   # Reload tmux configuration from ~/.tmux.conf
#
# Returns: Reloads tmux configuration for current session
# Behavior: Applies configuration changes without restarting tmux
function tsrc
    tmux source-file $HOME/.tmux.conf
end
