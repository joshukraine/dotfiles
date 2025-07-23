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

if ! command -v yq >/dev/null 2>&1; then
  echo "Error: yq is required but not installed. Install it with: brew install yq"
  exit 1
fi

if [[ ! -f "${YAML_FILE}" ]]; then
  echo "Error: YAML file not found: ${YAML_FILE}"
  exit 1
fi

echo "Generating abbreviations documentation from ${YAML_FILE}..."

# Count total abbreviations for each shell
total_count=$(yq eval '[.[] | to_entries[]] | length' "${YAML_FILE}")
fish_count=288  # Fish skips the "shell" category
zsh_count=${total_count}

# Get category count
category_count=$(yq eval 'keys | length' "${YAML_FILE}")

# Generate the documentation
cat >"${OUTPUT_FILE}" <<EOF
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
- Type \`ll\` + space → expands to \`eza -la\`

## Managing Abbreviations

### Regeneration

To update abbreviations after modifying \`shared/abbreviations.yaml\`:

\`\`\`bash
# Regenerate all abbreviation files and documentation
~/dotfiles/shared/generate-all-abbr.sh

# Or use the function (available in both shells)
reload-abbr
\`\`\`

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
    yq eval ".${category} | to_entries | .[] | \"| \`\" + .key + \"\` | \`\" + (.value | sub(\"\\|\"; \"\\\\|\"; \"g\")) + \"\` | \" + .key + \" |\"" "${YAML_FILE}"
    echo ""
  } >>"${OUTPUT_FILE}"
done

# Add cross-shell compatibility section
cat >>"${OUTPUT_FILE}" <<'EOF'
## Cross-Shell Compatibility

### Fish-Only Features

- Native abbreviation expansion
- Better completion integration

### Zsh-Only Features

- `src` abbreviation for reloading configuration
- Integration with Oh My Zsh plugins

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
  gnew: "git checkout -b"  # New branch shortcut
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

# Replace the placeholder with the evaluated date
sed -i '' "s/\$(date)/$(date)/" "${OUTPUT_FILE}"

echo "✅ Generated abbreviations documentation: ${OUTPUT_FILE}"
echo "📊 Total abbreviations documented: ${zsh_count} (${category_count} categories)"
