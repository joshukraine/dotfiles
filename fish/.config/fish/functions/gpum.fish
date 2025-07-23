# Push current branch to origin with upstream tracking to the default branch
#
# Usage: gpum [OPTION]
# Arguments:
#   -h, --help              Show help message
#
# Examples:
#   gpum                    # Push current branch to origin with upstream tracking
#   gpum --help             # Show help message
#
# Returns: 0 on success, 1 on error
function gpum
    # Show help message
    if test (count $argv) -gt 0
        switch $argv[1]
            case -h --help
                printf "%s\n" "Usage: gpum [OPTION]
Push current branch to origin with upstream tracking to the default branch.
Intelligently detects whether to use 'main' or 'master' as the default branch.

Options:
  -h, --help  Show this help message

Examples:
  gpum        # Push current branch to origin with upstream tracking"
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

    # Check if remote exists
    if not git remote | grep -q "^origin\$"
        echo "No 'origin' remote found."
        return 1
    end

    # Determine default branch
    set default_branch ""

    # Try to get default branch from remote
    set default_branch (git remote show origin 2> /dev/null | awk '/HEAD branch/ { print $NF }')

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

    echo "Pushing $current_branch to origin with upstream tracking..."
    git push -u origin $current_branch
    if test $status -ne 0
        echo "Failed to push to origin."
        return 1
    end

    echo "Successfully pushed $current_branch to origin (default branch: $default_branch)"
end
