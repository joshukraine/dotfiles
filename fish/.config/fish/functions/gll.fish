# Git log with detailed graph formatting and color highlighting
#
# Usage: gll [OPTIONS]
# Arguments:
#   All git log options are supported and passed through
#
# Examples:
#   gll                     # Show formatted git log with graph
#   gll -10                 # Show last 10 commits
#   gll --since="1 week"    # Show commits from last week
#   gll --author="John"     # Show commits by author John
#   gll --oneline          # Override with oneline format
#
# Returns: Formatted git log output with graph, colors, and commit details
function gll
    # Show help message
    if test (count $argv) -gt 0
        switch $argv[1]
            case -h --help
                printf "%s\n" "Usage: gll [OPTIONS]
Git log with detailed graph formatting and color highlighting.

This function provides a nicely formatted git log with:
- Graph visualization of branch structure
- Color-coded commit hashes, dates, and branch info
- Abbreviated commit hashes for cleaner display
- Author names and relative dates

Options:
  All standard git log options are supported:
  -n, --max-count=<number>    Limit number of commits
  --since=<date>             Show commits since date
  --until=<date>             Show commits until date
  --author=<pattern>         Show commits by author
  --grep=<pattern>           Search commit messages
  --oneline                  Use git's oneline format instead
  -h, --help                 Show this help message

Examples:
  gll                        # Show formatted git log
  gll -10                    # Show last 10 commits
  gll --since=\"1 week ago\"   # Show recent commits
  gll --author=\"Jane\"        # Show commits by Jane
  gll --grep=\"fix\"           # Search for commits mentioning 'fix'"
                return 0
        end
    end

    # Execute git log with custom formatting
    git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(bold white)— %an%C(reset)%C(bold yellow)%d%C(reset)' --abbrev-commit $argv
end
