# Enhanced cat command using bat for syntax highlighting and paging
#
# Usage: cat [file...]
# Arguments:
#   file... - Files to display (optional, can read from stdin)
#
# Examples:
#   cat script.sh           # Display file with syntax highlighting
#   cat *.md               # Display multiple markdown files
#   echo "hello" | cat     # Read from stdin with enhanced display
#
# Returns: Content of files with syntax highlighting, line numbers, and git integration
function cat
    bat $argv
end
