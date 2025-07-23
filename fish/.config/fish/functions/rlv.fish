# List available Ruby versions using asdf with filtering
#
# Usage: rlv
# Arguments: None
#
# Examples:
#   rlv                     # Show all installable Ruby versions (numeric only)
#
# Returns: Filtered list of Ruby versions available for installation via asdf, excluding preview/rc versions
function rlv
    asdf list-all ruby | rg '^\d'
end
