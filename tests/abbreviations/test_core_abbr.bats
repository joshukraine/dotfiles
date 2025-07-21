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
  test_abbreviation "gcm" "git commit -m"
  test_abbreviation "gco" "git checkout"
  test_abbreviation "gbr" "git branch -r"
}

@test "development utility abbreviations work" {
  test_abbreviation "ll" "ls -alF"
  test_abbreviation "la" "ls -A"
  test_abbreviation "mkdir" "mkdir -pv"
}

@test "tmux abbreviations are available" {
  test_abbreviation "tl" "tmux list-sessions"
  test_abbreviation "ta" "tmux attach-session -t"
  test_abbreviation "tn" "tmux new-session -s"
}

@test "system tool abbreviations work" {
  test_abbreviation "df" "df -h"
  test_abbreviation "du" "du -h"
  test_abbreviation "dud" "du -d 1 -h"
}

@test "fish and zsh abbreviations have parity" {
  # Test a subset of abbreviations for cross-shell parity
  local abbrs=("c" "ga" "gst" "brc" "cl" "ll" "tl" "df")
  
  for abbr in "${abbrs[@]}"; do
    # Get expected value from YAML source
    local expected=$(grep -A1 "^  $abbr:" "$DOTFILES_DIR/shared/abbreviations.yaml" | tail -1 | sed 's/.*: "\(.*\)"/\1/')
    
    # Test both shells if expected value found
    if [ -n "$expected" ]; then
      run test_abbreviation "$abbr" "$expected" "fish"
      [ "$status" -eq 0 ]
      
      run test_abbreviation "$abbr" "$expected" "zsh"
      [ "$status" -eq 0 ]
    fi
  done
}

@test "abbreviations file structure is valid" {
  # Check that abbreviations.yaml is valid YAML
  require_command "python3"
  
  run python3 -c "import yaml; yaml.safe_load(open('$DOTFILES_DIR/shared/abbreviations.yaml'))"
  [ "$status" -eq 0 ]
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
  local fish_count=$(grep -c "^abbr -a" "$DOTFILES_DIR/fish/.config/fish/abbreviations.fish" 2>/dev/null || echo "0")
  local zsh_count=$(grep -c "^abbr " "$DOTFILES_DIR/zsh/.config/zsh-abbr/abbreviations.zsh" 2>/dev/null || echo "0")
  
  # Allow for small differences due to shell-specific abbreviations
  local diff=$((fish_count - zsh_count))
  local abs_diff=${diff#-}  # absolute value
  
  # Difference should be small (less than 10)
  [ "$abs_diff" -lt 10 ]
}