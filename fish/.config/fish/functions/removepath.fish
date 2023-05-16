function removepath
    if set -l index (contains -i $argv[1] $PATH)
        set --erase --universal fish_user_paths[$index]
        echo "Updated PATH: $PATH"
    else
        echo "$argv[1] not found in PATH: $PATH"
    end
end
