#!/usr/bin/env bash

# Simple function documentation generator
#
# Generates an index of all functions with their brief descriptions

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
DOCS_DIR="$DOTFILES_DIR/docs/functions"
FISH_FUNCTIONS_DIR="$DOTFILES_DIR/fish/.config/fish/functions"
ZSH_FUNCTIONS_FILE="$DOTFILES_DIR/zsh/.config/zsh/functions.zsh"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Extract brief description from Fish function
extract_fish_brief() {
    local file="$1"
    local func_name
    func_name=$(basename "$file" .fish)

    # Look for the first comment line after the file starts
    local brief=""
    local found_comment=false

    while IFS= read -r line; do
        if [[ "$line" =~ ^#[[:space:]]* ]] && [[ ! "$found_comment" == true ]]; then
            # First comment line - this should be the brief description
            brief="${line#'#'}"
            brief="${brief# }"
            found_comment=true
            break
        elif [[ "$line" =~ ^function[[:space:]] ]]; then
            # Reached function definition without finding comment
            break
        fi
    done < "$file"

    if [[ -n "$brief" ]]; then
        echo "$func_name|$brief"
    fi
}

# Extract brief descriptions from Zsh functions
extract_zsh_briefs() {
    local file="$1"
    local in_function=false
    local current_func=""
    local brief=""

    while IFS= read -r line; do
        if [[ "$line" =~ ^#[[:space:]]* ]] && [[ "$in_function" == false ]]; then
            # Comment line before function
            brief="${line#'#'}"
            brief="${brief# }"
        elif [[ "$line" =~ ^function[[:space:]] ]]; then
            # Function definition found
            current_func="${line#function }"
            current_func="${current_func%%(*}"
            current_func="${current_func// /}"
            in_function=true

            if [[ -n "$brief" ]] && [[ -n "$current_func" ]]; then
                echo "$current_func|$brief"
            fi
            brief=""
        elif [[ "$line" =~ ^}[[:space:]]*$ ]]; then
            # End of function
            in_function=false
            current_func=""
            brief=""
        fi
    done < "$file"
}

# Generate comprehensive function index
generate_function_index() {
    local output_file="$DOCS_DIR/function-index.md"

    info "Generating function index..."

    cat > "$output_file" << EOF
# Function Index

Auto-generated comprehensive index of all documented functions in the dotfiles configuration.

*Last updated: $(date)*

## Quick Reference

| Function | Brief Description | Shell | File Location |
|----------|-------------------|-------|---------------|
EOF

    # Process Fish functions
    if [[ -d "$FISH_FUNCTIONS_DIR" ]]; then
        for file in "$FISH_FUNCTIONS_DIR"/*.fish; do
            if [[ -f "$file" ]]; then
                local func_data
                func_data=$(extract_fish_brief "$file")
                if [[ -n "$func_data" ]]; then
                    local func_name="${func_data%%|*}"
                    local brief="${func_data#*|}"
                    local rel_path="${file#$DOTFILES_DIR/}"
                    echo "| \`$func_name\` | $brief | Fish | \`$rel_path\` |" >> "$output_file"
                fi
            fi
        done
    fi

    # Process Zsh functions
    if [[ -f "$ZSH_FUNCTIONS_FILE" ]]; then
        local zsh_briefs
        zsh_briefs=$(extract_zsh_briefs "$ZSH_FUNCTIONS_FILE")
        local rel_path="${ZSH_FUNCTIONS_FILE#$DOTFILES_DIR/}"

        while IFS= read -r func_data; do
            if [[ -n "$func_data" ]]; then
                local func_name="${func_data%%|*}"
                local brief="${func_data#*|}"
                echo "| \`$func_name\` | $brief | Zsh | \`$rel_path\` |" >> "$output_file"
            fi
        done <<< "$zsh_briefs"
    fi

    cat >> "$output_file" << EOF

## Function Categories

### Smart Git Functions
Functions that intelligently detect default branches and handle git workflows:

$(grep "| \`g" "$output_file" | grep -E "(gcom|gpum|grbm|gbrm)" || echo "*No smart git functions found with documentation*")

### Development Utilities
Tools for development workflow and navigation:

$(grep -E "| \`(cd|reload|mm|src)" "$output_file" || echo "*No development utilities found with documentation*")

### System Functions
System utilities and command wrappers:

$(grep -E "| \`(cat|htop|ls|pi)" "$output_file" || echo "*No system functions found with documentation*")

### Tmux Functions
Session and window management:

$(grep -E "| \`t" "$output_file" || echo "*No tmux functions found with documentation*")

## Usage

Most functions include help flags or usage information:

\`\`\`bash
# Functions with help flags
gcom --help
gpum --help
reload-abbr --help

# Functions that show usage when called incorrectly
ta                  # Shows usage
tk                  # Shows usage
tn                  # Shows usage
\`\`\`

## Related Documentation

- [Complete Function Documentation](README.md) - Detailed documentation for all functions
- [Abbreviations Reference](../abbreviations.md) - Shell abbreviation reference
- [Main README](../../README.md) - Repository overview and setup

---

*This index is automatically generated from inline function documentation.*
EOF

    success "Generated function index at $output_file"
}

# Main execution
main() {
    info "Starting function documentation generation..."

    if [[ ! -d "$DOCS_DIR" ]]; then
        mkdir -p "$DOCS_DIR"
    fi

    generate_function_index

    success "Function documentation generation completed!"
}

main "$@"
