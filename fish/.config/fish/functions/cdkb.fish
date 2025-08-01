function cdkb --description "Quick navigation to Claude Code Knowledge Base"
    set -l kb_path (test -n "$CLAUDE_KB_PATH"; and echo $CLAUDE_KB_PATH; or echo "$HOME/claude-knowledge-base")

    if not test -d $kb_path
        echo "Knowledge base not found at: $kb_path"
        echo "Ensure CLAUDE_KB_PATH is set and directory exists"
        echo "Create with: mkdir -p ~/claude-knowledge-base"
        return 1
    end

    cd $kb_path
    echo "📚 Knowledge Base: "(pwd)
    echo ""
    echo "💡 Search: rg 'search term' --type md"
    echo ""
    echo "Recent additions:"
    find . -name "*.md" -not -path "./.*" -type f -print0 | \
        xargs -0 ls -t | head -5 | \
        sed 's|^\./||' | \
        while read -l file
            echo "  $file"
        end
end
