#!/usr/bin/env bats

# Tests for core shell abbreviations

load '../helpers/common.bash'
load '../helpers/shell_helpers.bash'

setup() {
  # Ensure abbreviation files exist
  require_file "$DOTFILES_DIR/shared/abbreviations.yaml"
}

@test "core unix abbreviations are defined correctly" {
  # Test a few key abbreviations from different categories
  test_abbreviation "c" "clear"
  test_abbreviation "ga" "git add"
  test_abbreviation "gst" "git status"
}

@test "homebrew abbreviations work in both shells" {
  test_abbreviation "brc" "brew cleanup"
  test_abbreviation "bru" "brew update"
  test_abbreviation "brg" "brew upgrade"
}

@test "claude code abbreviations are properly defined" {
  test_abbreviation "cl" "claude"
  test_abbreviation "clh" "claude --help"
  test_abbreviation "clv" "claude --version"
}

@test "git abbreviations have consistent expansions" {
  test_abbreviation "gaa" "git add --all"
  test_abbreviation "gcm" "git cm"
  test_abbreviation "gco" "git checkout"
  test_abbreviation "gbr" "git branch --remote"
}

@test "development utility abbreviations work" {
  test_abbreviation "cv" "command -v"
  test_abbreviation "mkdir" "mkdir -pv"
  test_abbreviation "mv" "mv -iv"
}

@test "tmux abbreviations are available" {
  test_abbreviation "tl" "tmux ls"
  test_abbreviation "tlw" "tmux list-windows"
}

@test "system tool abbreviations work" {
  test_abbreviation "df" "df -h"
  test_abbreviation "du" "du -h"
  test_abbreviation "dud" "du -d 1 -h"
}

@test "fish and zsh abbreviations have parity" {
  # Test a subset of abbreviations for cross-shell parity
  # Use abbreviations that should exist in both files
  local test_pairs=(
    "c:clear"
    "df:df -h"
    "du:du -h"
    "mkdir:mkdir -pv"
  )

  for pair in "${test_pairs[@]}"; do
    local abbr="${pair%:*}"
    local expected="${pair#*:}"

    # Test both shells
    run test_abbreviation "$abbr" "$expected" "fish"
    [ "$status" -eq 0 ]

    run test_abbreviation "$abbr" "$expected" "zsh"
    [ "$status" -eq 0 ]
  done
}

@test "abbreviations file structure is valid" {
  # Check that abbreviations.yaml file exists and has basic YAML structure
  local yaml_file="$DOTFILES_DIR/shared/abbreviations.yaml"
  assert_file_exists "$yaml_file"

  # Basic YAML validation - check for common YAML patterns
  run grep -E "^[a-zA-Z_]+:" "$yaml_file"
  [ "$status" -eq 0 ]

  # Check that it's not empty and has abbreviation entries
  local abbr_count
  abbr_count=$(grep -c "^  [a-zA-Z].*:" "$yaml_file")
  [ "$abbr_count" -gt 0 ]
}

@test "generated abbreviation files exist and are not empty" {
  local fish_abbr_file="$DOTFILES_DIR/fish/.config/fish/abbreviations.fish"
  local zsh_abbr_file="$DOTFILES_DIR/zsh/.config/zsh-abbr/abbreviations.zsh"

  assert_file_exists "$fish_abbr_file"
  assert_file_exists "$zsh_abbr_file"

  # Check files are not empty
  [ -s "$fish_abbr_file" ]
  [ -s "$zsh_abbr_file" ]
}

@test "abbreviation count matches between shells" {
  local fish_count
  local zsh_count
  fish_count=$(grep -c "^abbr -a" "$DOTFILES_DIR/fish/.config/fish/abbreviations.fish" 2>/dev/null || echo "0")
  zsh_count=$(grep -c "^abbr " "$DOTFILES_DIR/zsh/.config/zsh-abbr/abbreviations.zsh" 2>/dev/null || echo "0")

  # Allow for small differences due to shell-specific abbreviations
  local diff=$((fish_count - zsh_count))
  local abs_diff=${diff#-}  # absolute value

  # Difference should be small (less than 10)
  [ "$abs_diff" -lt 10 ]
}
