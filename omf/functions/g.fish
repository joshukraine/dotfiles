# No arguments: `git status`
# With arguments: acts like `git`
function g
    if count $argv >/dev/null
        git $argv
    else
        git status
    end
end
