function cdkb --description "Quick navigation to Personal Knowledge Base"
    set -l kb_path (test -n "$PKB_PATH"; and echo $PKB_PATH; or echo "$HOME/personal-knowledge-base")

    if not test -d $kb_path
        echo "Knowledge base not found at: $kb_path"
        echo "Ensure PKB_PATH is set and directory exists"
        echo "Create with: mkdir -p ~/personal-knowledge-base"
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
