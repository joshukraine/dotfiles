function dsx -d "Recursively remove all .DS_Store files"
    set count (fd -HI '^\.DS_Store$' --type f | wc -l)

    if test ! $count -eq 0
        fd -HI '^\.DS_Store$' --type f -X rm
        echo "$count .DS_Store files removed."
    else
        echo "No .DS_Store files were found."
    end
end
