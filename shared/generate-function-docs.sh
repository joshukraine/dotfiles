#!/usr/bin/env bash

# Generate function documentation from inline comments
#
# This script parses Fish and Zsh function files to extract inline documentation
# and generates comprehensive markdown documentation files.

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
DOCS_DIR="$DOTFILES_DIR/docs/functions"
FISH_FUNCTIONS_DIR="$DOTFILES_DIR/fish/.config/fish/functions"
ZSH_FUNCTIONS_FILE="$DOTFILES_DIR/zsh/.config/zsh/functions.zsh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

# Extract documentation from Fish function file
extract_fish_function_doc() {
    local file="$1"
    local func_name
    func_name=$(basename "$file" .fish)

    # Extract comment block before function definition
    local doc_block=""
    local in_comment_block=false

    while IFS= read -r line; do
        if [[ "$line" =~ ^#[[:space:]]* ]]; then
            # This is a comment line
            in_comment_block=true
            # Remove leading # and optional space
            local comment_content="${line#'#'}"
            comment_content="${comment_content# }"
            doc_block="${doc_block}$comment_content"$'\n'
        elif [[ "$line" =~ ^function[[:space:]]+$func_name ]]; then
            # Found function definition, stop extracting
            break
        elif [[ -n "$line" ]] && [[ ! "$line" =~ ^[[:space:]]*$ ]]; then
            # Non-empty, non-comment line - reset if we haven't found function yet
            if ! $in_comment_block; then
                doc_block=""
            fi
        fi
    done < "$file"

    if [[ -n "$doc_block" ]]; then
        echo "$func_name|$doc_block"
    fi
}

# Extract documentation from Zsh functions file
extract_zsh_function_docs() {
    local file="$1"
    local current_func=""
    local doc_block=""
    local in_comment_block=false
    local functions_found=()

    while IFS= read -r line; do
        if [[ "$line" =~ ^#[[:space:]]* ]]; then
            # This is a comment line
            in_comment_block=true
            local comment_content="${line#'#'}"
            comment_content="${comment_content# }"
            doc_block="${doc_block}$comment_content"$'\n'
        elif [[ "$line" =~ ^function[[:space:]]+([^(]+)\(\)[[:space:]]* ]]; then
            # Found function definition
            if [[ -n "$current_func" ]] && [[ -n "$doc_block" ]]; then
                # Save previous function's documentation
                functions_found+=("$current_func|$doc_block")
            fi

            # Start new function
            current_func="${BASH_REMATCH[1]}"
            if $in_comment_block && [[ -n "$doc_block" ]]; then
                # Documentation block found for this function
                :
            else
                doc_block=""
            fi
            in_comment_block=false
        elif [[ "$line" =~ ^} ]]; then
            # End of function
            if [[ -n "$current_func" ]] && [[ -n "$doc_block" ]]; then
                functions_found+=("$current_func|$doc_block")
            fi
            current_func=""
            doc_block=""
            in_comment_block=false
        elif [[ -n "$line" ]] && [[ ! "$line" =~ ^[[:space:]]*$ ]]; then
            # Non-empty, non-comment line
            if ! $in_comment_block; then
                doc_block=""
            fi
        fi
    done < "$file"

    # Handle last function if file doesn't end with }
    if [[ -n "$current_func" ]] && [[ -n "$doc_block" ]]; then
        functions_found+=("$current_func|$doc_block")
    fi

    printf '%s\n' "${functions_found[@]}"
}

# Parse documentation block into structured data
parse_doc_block() {
    local doc_block="$1"
    local brief=""
    local usage=""
    local args=""
    local examples=""
    local returns=""
    local current_section=""

    while IFS= read -r line; do
        # Skip empty lines at start
        if [[ -z "$line" ]] && [[ -z "$brief$usage$args$examples$returns" ]]; then
            continue
        fi

        if [[ "$line" =~ ^Usage:[[:space:]]* ]]; then
            current_section="usage"
            usage="${line#Usage:}"
            usage="${usage# }"
        elif [[ "$line" =~ ^Arguments:[[:space:]]* ]]; then
            current_section="args"
        elif [[ "$line" =~ ^Examples:[[:space:]]* ]]; then
            current_section="examples"
        elif [[ "$line" =~ ^Returns:[[:space:]]* ]]; then
            current_section="returns"
            returns="${line#Returns:}"
            returns="${returns# }"
        elif [[ "$line" =~ ^[[:space:]]*$ ]]; then
            # Empty line
            case "$current_section" in
                args) args="${args}"$'\n' ;;
                examples) examples="${examples}"$'\n' ;;
            esac
        else
            case "$current_section" in
                "")
                    if [[ -z "$brief" ]]; then
                        brief="$line"
                    else
                        brief="${brief} $line"
                    fi
                    ;;
                usage) usage="${usage} $line" ;;
                args) args="${args}$line"$'\n' ;;
                examples) examples="${examples}$line"$'\n' ;;
                returns) returns="${returns} $line" ;;
            esac
        fi
    done <<< "$doc_block"

    echo "BRIEF:$brief"
    echo "USAGE:$usage"
    echo "ARGS:$args"
    echo "EXAMPLES:$examples"
    echo "RETURNS:$returns"
}

# Generate function reference index
generate_function_index() {
    local output_file="$DOCS_DIR/function-index.md"
    local temp_file
    temp_file=$(mktemp)

    info "Generating function index..."

    cat > "$temp_file" << 'EOF'
# Function Index

Auto-generated index of all documented functions in the dotfiles configuration.

## Quick Reference

| Function | Brief Description | Shell | Category |
|----------|-------------------|-------|----------|
EOF

    # Process Fish functions
    if [[ -d "$FISH_FUNCTIONS_DIR" ]]; then
        for file in "$FISH_FUNCTIONS_DIR"/*.fish; do
            if [[ -f "$file" ]]; then
                local func_doc
                func_doc=$(extract_fish_function_doc "$file")
                if [[ -n "$func_doc" ]]; then
                    local func_name="${func_doc%%|*}"
                    local doc_block="${func_doc#*|}"
                    local parsed
                    parsed=$(parse_doc_block "$doc_block")
                    local brief
                    brief=$(echo "$parsed" | grep "^BRIEF:" | cut -d: -f2-)

                    echo "| \`$func_name\` | $brief | Fish | TBD |" >> "$temp_file"
                fi
            fi
        done
    fi

    # Process Zsh functions
    if [[ -f "$ZSH_FUNCTIONS_FILE" ]]; then
        local zsh_docs
        zsh_docs=$(extract_zsh_function_docs "$ZSH_FUNCTIONS_FILE")
        while IFS= read -r func_doc; do
            if [[ -n "$func_doc" ]]; then
                local func_name="${func_doc%%|*}"
                local doc_block="${func_doc#*|}"
                local parsed
                parsed=$(parse_doc_block "$doc_block")
                local brief
                brief=$(echo "$parsed" | grep "^BRIEF:" | cut -d: -f2-)

                echo "| \`$func_name\` | $brief | Zsh | TBD |" >> "$temp_file"
            fi
        done <<< "$zsh_docs"
    fi

    cat >> "$temp_file" << 'EOF'

## Cross-Shell Compatibility Matrix

| Function | Fish | Zsh | Notes |
|----------|------|-----|-------|
EOF

    # TODO: Add cross-shell compatibility analysis

    cat >> "$temp_file" << "EOF"

---

*This index is auto-generated from function inline documentation. Last updated: $(date)*
EOF

    mv "$temp_file" "$output_file"

    success "Generated function index at $output_file"
}

# Main execution
main() {
    info "Starting function documentation generation..."

    # Check dependencies
    if [[ ! -d "$DOCS_DIR" ]]; then
        info "Creating docs/functions directory..."
        mkdir -p "$DOCS_DIR"
    fi

    # Generate function index
    generate_function_index

    success "Function documentation generation completed!"
    echo
    info "Generated files:"
    echo "  - $DOCS_DIR/function-index.md"
    echo
    info "To regenerate, run: $0"
}

# Run main function
main "$@"
