# Interactive process viewer with elevated privileges
#
# Usage: htop
# Arguments: None
#
# Examples:
#   htop                    # Launch htop with sudo for full system visibility
#
# Returns: Runs htop interactively with root privileges for complete process management
function htop
    sudo htop
end
