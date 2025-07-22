#!/usr/bin/env bash
#
# Shared utilities for abbreviation generator scripts
# Usage: source generator-utils.sh

# Configuration for shell-specific categories
# Categories in this array will be skipped by the Fish generator
FISH_SKIP_CATEGORIES=("shell")

# Categories in this array will be skipped by the Zsh generator
ZSH_SKIP_CATEGORIES=()

# Convert category name to title case for section headers
to_title_case() {
  local input="$1"
  echo "$input" | tr '_' ' ' | sed 's/\b\w/\U&/g'
}

# Check if a category should be skipped for the given shell
should_skip_category() {
  local shell="$1"
  local category="$2"

  case "$shell" in
    "fish")
      # Safe array iteration that handles empty arrays
      for skip_cat in "${FISH_SKIP_CATEGORIES[@]+"${FISH_SKIP_CATEGORIES[@]}"}"; do
        if [[ "$category" == "$skip_cat" ]]; then
          return 0 # Should skip
        fi
      done
      ;;
    "zsh")
      # Safe array iteration that handles empty arrays
      for skip_cat in "${ZSH_SKIP_CATEGORIES[@]+"${ZSH_SKIP_CATEGORIES[@]}"}"; do
        if [[ "$category" == "$skip_cat" ]]; then
          return 0 # Should skip
        fi
      done
      ;;
    *)
      echo "Error: Unknown shell type '$shell'" >&2
      exit 1
      ;;
  esac

  return 1 # Should not skip
}

