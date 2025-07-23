# Reload Fish shell configuration and restart session
#
# Usage: src
# Arguments: None
#
# Examples:
#   src                     # Restart Fish shell with fresh configuration
#
# Returns: Replaces current shell session with new Fish instance, loading all config changes
function src
    exec fish
end
