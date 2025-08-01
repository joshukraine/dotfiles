function cdkb --description "Quick navigation to Claude Code Knowledge Base"
    set -l kb_path (test -n "$CLAUDE_KB_PATH"; and echo $CLAUDE_KB_PATH; or echo "$HOME/claude-knowledge-base")
    set -l target_dir $kb_path

    if test (count $argv) -gt 0
        set target_dir $kb_path/$argv[1]
    end

    if not test -d $target_dir
        echo "Knowledge base not found at: $target_dir"
        echo "Run 'setup-knowledge-base' to initialize"
        return 1
    end

    cd $target_dir
    echo "📚 Knowledge Base: "(pwd)

    # Show recent files if in root
    if test $target_dir = $kb_path
        echo ""
        echo "Recent additions:"
        find . -name "*.md" -not -path "./.*" -type f -print0 | \
            xargs -0 ls -t | head -5 | \
            sed 's|^\./||' | \
            while read -l file
                echo "  $file"
            end
    end
end
