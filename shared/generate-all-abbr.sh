#!/usr/bin/env bash
#
# Generate abbreviations for all shells from shared YAML source
# Usage: ./generate-all-abbr.sh
#
# This script runs both Fish and Zsh abbreviation generators

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
YAML_FILE="${SCRIPT_DIR}/abbreviations.yaml"

echo "🚀 Regenerating abbreviations for all shells from ${YAML_FILE}..."
echo

# Check dependencies
if ! command -v yq >/dev/null 2>&1; then
  echo "❌ Error: yq is required but not installed. Install it with: brew install yq"
  exit 1
fi

if [[ ! -f "${YAML_FILE}" ]]; then
  echo "❌ Error: YAML file not found: ${YAML_FILE}"
  exit 1
fi

# Track success/failure
fish_success=false
zsh_success=false
doc_success=false

# Generate Fish abbreviations
echo "🐟 Generating Fish abbreviations..."
if "${SCRIPT_DIR}/generate-fish-abbr.sh"; then
  fish_success=true
else
  echo "❌ Failed to generate Fish abbreviations"
fi

echo

# Generate Zsh abbreviations
echo "⚡ Generating Zsh abbreviations..."
if "${SCRIPT_DIR}/generate-zsh-abbr.sh"; then
  zsh_success=true
else
  echo "❌ Failed to generate Zsh abbreviations"
fi

echo

# Generate documentation if both abbreviation files succeeded
if ${fish_success} && ${zsh_success}; then
  echo "📝 Generating abbreviations documentation..."
  if "${SCRIPT_DIR}/generate-abbreviations-doc.sh"; then
    doc_success=true
  else
    echo "❌ Failed to generate abbreviations documentation"
  fi
  echo
fi

echo "📋 Summary:"

if ${fish_success}; then
  echo "  ✅ Fish abbreviations generated successfully"
else
  echo "  ❌ Fish abbreviations failed"
fi

if ${zsh_success}; then
  echo "  ✅ Zsh abbreviations generated successfully"
else
  echo "  ❌ Zsh abbreviations failed"
fi

if ${fish_success} && ${zsh_success}; then
  if ${doc_success}; then
    echo "  ✅ Abbreviations documentation generated successfully"
  else
    echo "  ❌ Abbreviations documentation failed"
  fi
fi

# Overall success check
if ${fish_success} && ${zsh_success}; then
  echo
  echo "🎉 All abbreviations generated successfully!"
  echo
  echo "💡 To reload your current shell:"
  echo "  Fish: exec fish (or open new terminal)"
  echo "  Zsh:  src (or open new terminal)"
  exit 0
else
  echo
  echo "⚠️  Some abbreviation generation failed. Check the output above."
  exit 1
fi
