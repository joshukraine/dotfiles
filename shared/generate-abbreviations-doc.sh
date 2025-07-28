#!/usr/bin/env bash
#
# Generate abbreviations documentation from shared YAML source
# Usage: ./generate-abbreviations-doc.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load shared utilities
source "${SCRIPT_DIR}/generator-utils.sh"
YAML_FILE="${SCRIPT_DIR}/abbreviations.yaml"
OUTPUT_FILE="${SCRIPT_DIR}/../docs/abbreviations.md"

# Check for required tools
if ! command -v yq >/dev/null 2>&1; then
  echo "Error: yq is required but not installed. Install it with: brew install yq"
  exit 1
fi

if ! command -v prettier >/dev/null 2>&1; then
  echo "Error: prettier is required but not installed. Install it with: brew install prettier"
  exit 1
fi

if [[ ! -f "${YAML_FILE}" ]]; then
  echo "Error: YAML file not found: ${YAML_FILE}"
  exit 1
fi

echo "Generating abbreviations documentation from ${YAML_FILE}..."

# Count total abbreviations for each shell
total_count=$(yq eval '[.[] | to_entries[]] | length' "${YAML_FILE}")
fish_count=288 # Fish skips the "shell" category
zsh_count=${total_count}

# Get category count
category_count=$(yq eval 'keys | length' "${YAML_FILE}")

# Generate the documentation to a temporary file first
TEMP_FILE="${OUTPUT_FILE}.tmp"
cat >"${TEMP_FILE}" <<EOF
# Shell Abbreviations Reference

This document provides a comprehensive reference for all shell abbreviations available in both Fish and Zsh shells. Abbreviations are automatically generated from the single source of truth: \`shared/abbreviations.yaml\`.

## Overview

- **Total abbreviations**: ${zsh_count} (${fish_count} in Fish, ${zsh_count} in Zsh)
- **Categories**: ${category_count}
- **Source file**: \`shared/abbreviations.yaml\`
- **Generated files**:
  - Fish: \`fish/.config/fish/abbreviations.fish\`
  - Zsh: \`zsh/.config/zsh-abbr/abbreviations.zsh\`

## Usage

Abbreviations expand automatically when you press space or enter. For example:

- Type \`gst\` + space → expands to \`git status\`
- Type \`dcu\` + space → expands to \`docker compose up\`

## Managing Abbreviations

### Regeneration

To update abbreviations after modifying \`shared/abbreviations.yaml\`:

\`\`\`bash
reload-abbr
\`\`\`

The \`reload-abbr\` function provides:
- Comprehensive error checking and validation
- Regenerates both abbreviations and function documentation
- Built-in help with \`reload-abbr --help\`
- User-friendly output and guidance

### Shell Differences

- **Fish**: Uses native abbreviations (\`abbr\` command)
- **Zsh**: Uses \`zsh-abbr\` plugin to provide Fish-like behavior
- Most abbreviations work identically in both shells
- Some shell-specific abbreviations exist (e.g., \`src\` for Zsh only)

## Abbreviation Categories

EOF

# Process each category in the YAML file
yq eval 'keys | .[]' "${YAML_FILE}" | while read -r category; do
  category_title=$(to_title_case "${category}")

  # Get category description based on category name
  case "${category}" in
    "unix")
      description="Basic system utilities with enhanced options:"
      ;;
    "system")
      description="System information and management:"
      ;;
    "claude_code")
      description="AI assistant shortcuts:"
      ;;
    "homebrew")
      description="Homebrew shortcuts with common options:"
      ;;
    "config_dirs")
      description="Quick access to common directories:"
      ;;
    "navigation")
      description="Enhanced directory navigation:"
      ;;
    "tree")
      description="Enhanced directory listing with \`eza\`:"
      ;;
    "dev_tools")
      description="Programming and development utilities:"
      ;;
    "git")
      description="Comprehensive git workflow shortcuts:"
      ;;
    "docker")
      description="Container management shortcuts:"
      ;;
    "rails")
      description="Ruby on Rails shortcuts:"
      ;;
    "tmux")
      description="Terminal multiplexer shortcuts:"
      ;;
    "npm")
      description="JavaScript development tools:"
      ;;
    "shell")
      description="Shell-specific operations:"
      ;;
    *)
      description="$(echo "${category}" | tr '_' ' ' | sed 's/\b\w/\U&/g') utilities:"
      ;;
  esac

  {
    echo "### ${category_title}"
    echo ""
    echo "${description}"
    echo ""
    echo "| Abbr | Command | Description |"
    echo "|------|---------|-------------|"

    # Generate table rows for this category
    yq eval ".${category} | to_entries | .[] | \"| \`\" + .key + \"\` | \`\" + ((.value.command // .value) | sub(\"\\|\"; \"\\\\|\"; \"g\")) + \"\` | \" + (.value.description // .key) + \" |\"" "${YAML_FILE}"
    echo ""
  } >>"${TEMP_FILE}"
done

# Add cross-shell compatibility section
cat >>"${TEMP_FILE}" <<'EOF'
## Cross-Shell Compatibility

### Fish-Only Features

- Native abbreviation expansion
- Better completion integration

### Zsh-Only Features

- `src` abbreviation for reloading configuration
- Integration with Zap plugin manager

### Shared Features

- All abbreviations work identically
- Same expansion behavior
- Consistent command structure

## Customization

### Adding New Abbreviations

1. Edit `shared/abbreviations.yaml`
2. Add to appropriate category
3. Run `reload-abbr` to regenerate files
4. Reload your shell configuration

### Example Addition

```yaml
# In shared/abbreviations.yaml
git:
  gnew:
    command: "git checkout -b"
    description: "Create and checkout new branch"
```

### Category Guidelines

- **unix**: Basic UNIX commands and utilities
- **git**: Git version control operations
- **dev_tools**: Development and programming tools
- **navigation**: Directory and file navigation
- **system**: System administration and information

## Related Documentation

- [Function Documentation](functions/README.md) - Shell function reference
- [Git Functions](functions/git-functions.md) - Smart git operations
- [Development Tools](functions/development.md) - Development utilities
- [Tmux Functions](functions/tmux.md) - Terminal multiplexer management

---

*This file is automatically generated from `shared/abbreviations.yaml`. Do not edit directly.*
*Last generated: $(date)*
EOF

# Replace the placeholder with the evaluated date in the temporary file
sed -i '' "s/\$(date)/$(date)/" "${TEMP_FILE}"

# Apply markdown formatting pipeline to temp file (matches LazyVim behavior from commit a53f0bd)
echo "🎨 Applying markdown formatting pipeline..."

# Format with prettier using default settings (same as LazyVim)
if prettier_error=$(prettier --parser=markdown --write "${TEMP_FILE}" 2>&1); then
  echo "✅ Formatted with Prettier (defaults): ${TEMP_FILE}"
else
  echo "⚠️  Warning: Prettier formatting failed, continuing without formatting"
  echo "   Error: ${prettier_error}"
fi

# Then run markdownlint to fix any remaining linting issues
if command -v markdownlint-cli2 >/dev/null 2>&1; then
  if markdownlint-cli2 --config ~/.markdownlint.yaml --fix "${TEMP_FILE}" >/dev/null 2>&1; then
    echo "✅ Applied markdownlint fixes: ${TEMP_FILE}"
  else
    echo "⚠️  Warning: markdownlint fixes failed, but continuing"
  fi
else
  echo "⚠️  Warning: markdownlint-cli2 not found, skipping linting step"
fi

# Now compare the formatted content (excluding timestamp) to see if we need to update
if [[ -f "${OUTPUT_FILE}" ]]; then
  # Extract content without timestamp for comparison
  grep -v "Last generated:" "${TEMP_FILE}" >"${TEMP_FILE}.new" 2>/dev/null || true
  grep -v "Last generated:" "${OUTPUT_FILE}" >"${TEMP_FILE}.old" 2>/dev/null || true

  if cmp -s "${TEMP_FILE}.new" "${TEMP_FILE}.old" 2>/dev/null; then
    # Content is identical, keep original file to preserve timestamp
    rm -f "${TEMP_FILE}" "${TEMP_FILE}.new" "${TEMP_FILE}.old"
    echo "✅ Abbreviations documentation unchanged: ${OUTPUT_FILE}"
    echo "📊 Total abbreviations: ${zsh_count} (${category_count} categories)"
    exit 0
  fi

  # Clean up comparison files
  rm -f "${TEMP_FILE}.new" "${TEMP_FILE}.old"
fi

# Content has changed or file doesn't exist, use the new version
mv "${TEMP_FILE}" "${OUTPUT_FILE}"

echo "✅ Generated abbreviations documentation: ${OUTPUT_FILE}"
echo "📊 Total abbreviations documented: ${zsh_count} (${category_count} categories)"
