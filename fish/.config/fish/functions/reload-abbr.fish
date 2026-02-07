function reload-abbr
    # Show help message
    if test (count $argv) -gt 0
        switch $argv[1]
            case -h --help
                printf "%s\n" "Usage: reload-abbr [OPTION]
Regenerate abbreviations and function documentation from source files.
This command can be run from any directory.

What gets regenerated:
  - Fish abbreviations (fish/.config/fish/abbreviations.fish)
  - Zsh abbreviations (zsh/.config/zsh-abbr/abbreviations.zsh)
  - Abbreviations documentation (docs/abbreviations.md)

Options:
  -h, --help  Show this help message

Examples:
  reload-abbr  # Regenerate all abbreviations and function docs"
                return 0
        end
    end

    # Find the dotfiles directory
    set dotfiles_dir "$HOME/dotfiles"
    if not test -d "$dotfiles_dir"
        echo "❌ Error: Dotfiles directory not found at $dotfiles_dir"
        return 1
    end

    # Check if the generation script exists
    set generate_script "$dotfiles_dir/shared/generate-all-abbr.sh"
    if not test -f "$generate_script"
        echo "❌ Error: Generation script not found at $generate_script"
        return 1
    end

    # Check if script is executable
    if not test -x "$generate_script"
        echo "❌ Error: Generation script is not executable: $generate_script"
        echo "Run: chmod +x $generate_script"
        return 1
    end

    # Check if documentation generators exist
    set doc_generate_script "$dotfiles_dir/shared/generate-abbreviations-doc.sh"
    # Run the generation script
    echo "🔄 Regenerating abbreviations and documentation from any directory..."
    "$generate_script"
    set exit_code $status

    # Also regenerate documentation if generators exist and abbreviations succeeded
    if test $exit_code -eq 0
        if test -f "$doc_generate_script" -a -x "$doc_generate_script"
            echo "📝 Regenerating abbreviations documentation..."
            "$doc_generate_script"
        end
    end

    if test $exit_code -eq 0
        echo
        echo "💡 Don't forget to reload your shell to use the new abbreviations:"
        echo "   Fish: exec fish"
        echo "   Zsh:  src"
    end

    return $exit_code
end
