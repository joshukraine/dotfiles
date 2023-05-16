function gwip
    git add -A
    git rm (git ls-files --deleted) 2>/dev/null
    git commit --no-verify -m "--wip--"
end
