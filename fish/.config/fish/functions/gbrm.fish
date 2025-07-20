function gbrm
    # Check if we're in a Git repository
    git rev-parse --is-inside-work-tree >/dev/null 2>&1
    if test $status -ne 0
        echo "Not a git repository."
        return 1
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

    echo "Removing branches merged into $default_branch..."
    git branch --merged $default_branch | grep -v "^\*\|  $default_branch" | xargs -n 1 git branch -d
end
