function sha256
    printf "%s %s\n" "$argv[1]" "$argv[2]" | sha256sum --check
end
