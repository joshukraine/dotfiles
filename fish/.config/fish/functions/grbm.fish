# Rebase current branch against the default branch (main or master)
#
# Usage: grbm [OPTION]
# Arguments:
#   -h, --help              Show help message
#
# Examples:
#   grbm                    # Rebase current branch against default branch
#   grbm --help             # Show help message
#
# Returns: 0 on success, 1 on error (including rebase conflicts)
function grbm
    # Show help message
    if test (count $argv) -gt 0
        switch $argv[1]
            case -h --help
                printf "%s\n" "Usage: grbm [OPTION]
Rebase current branch against the default branch (main or master).
Intelligently detects the default branch and fetches latest changes.

Options:
  -h, --help  Show this help message

Examples:
  grbm        # Rebase current branch against default branch"
                return 0
        end
    end

    # Check if we're in a Git repository
    git rev-parse --is-inside-work-tree >/dev/null 2>&1
    if test $status -ne 0
        echo "Not a git repository."
        return 1
    end

    # Get current branch
    set current_branch (git branch --show-current)
    if test -z "$current_branch"
        echo "Could not determine current branch."
        return 1
    end

    # Check for uncommitted changes
    if not git-check-uncommitted --prompt
        return 1
    end

    # Check if remote exists and fetch
    if git remote | grep -q "^origin\$"
        echo "Fetching latest from origin..."
        git fetch origin >/dev/null 2>&1
        if test $status -ne 0
            echo "Failed to fetch from origin."
            return 1
        end
    end

    # Determine default branch
    set default_branch ""

    # Try to get default branch from remote
    if git remote | grep -q "^origin\$"
        set default_branch (git remote show origin 2> /dev/null | awk '/HEAD branch/ { print $NF }')
    end

    # Fallback if needed
    if test -z "$default_branch"
        if git show-ref --quiet refs/heads/main
            set default_branch main
        else if git show-ref --quiet refs/heads/master
            set default_branch master
        else
            echo "Could not determine default branch."
            return 1
        end
    end

    # Don't rebase if we're already on the default branch
    if test "$current_branch" = "$default_branch"
        echo "Already on default branch ($default_branch). Nothing to rebase."
        return 0
    end

    # Check if we have origin remote before rebasing
    if not git remote | grep -q "^origin\$"
        echo "No 'origin' remote found. Cannot rebase against remote branch."
        return 1
    end

    echo "Rebasing $current_branch against $default_branch..."
    git rebase origin/$default_branch
    if test $status -ne 0
        echo "Rebase failed. You may need to resolve conflicts manually."
        return 1
    end

    echo "Successfully rebased $current_branch against origin/$default_branch"
end
