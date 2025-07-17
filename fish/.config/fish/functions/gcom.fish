function gcom
    # Show help message
    if test (count $argv) -gt 0
        switch $argv[1]
            case -h --help
                printf "%s\n" "Usage: gcom [OPTION]
Switch to the default Git branch (e.g., main or master), with optional pull.

Options:
  -p          Pull latest changes after switching to the default branch
  -h, --help  Show this help message

Examples:
  gcom        # Checkout default branch only
  gcom -p     # Checkout default branch and pull latest changes"
                return 0
        end
    end

    # Pull flag
    set do_pull 0
    if test (count $argv) -gt 0
        if test "$argv[1]" = -p
            set do_pull 1
        end
    end

    # Check if we're in a Git repository
    git rev-parse --is-inside-work-tree >/dev/null 2>&1
    if test $status -ne 0
        echo "Not a git repository."
        return 1
    end

    # Check for uncommitted changes
    if not git diff-index --quiet HEAD --
        echo "Warning: You have uncommitted changes. Consider committing or stashing them first."
        read -P "Continue anyway? (y/N): " -l response
        if test "$response" != y -a "$response" != Y
            echo "Aborted."
            return 1
        end
    end

    echo "Fetching latest from origin..."
    git fetch origin >/dev/null 2>&1
    if test $status -ne 0
        echo "Failed to fetch from origin."
        return 1
    end

    # Try to get the default branch from remote
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

    echo "Switching to $default_branch"
    git checkout $default_branch
    if test $status -ne 0
        echo "Failed to checkout $default_branch"
        return 1
    end

    if test $do_pull -eq 1
        echo "Pulling latest changes..."
        git pull
        if test $status -ne 0
            echo "Failed to pull changes."
            return 1
        end
    end
end
