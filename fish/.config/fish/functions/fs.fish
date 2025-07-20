function fs -d "Get file/directory size"
    # Check if du supports -b flag (GNU du)
    if du -b /dev/null >/dev/null 2>&1
        set arg -sbh
    else
        set arg -sh
    end
    
    if test (count $argv) -gt 0
        du $arg -- $argv
    else
        du $arg .[^.]* * 2>/dev/null
    end
end