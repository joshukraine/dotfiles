#!/usr/bin/env bash

# Shell environment test helpers for dotfiles testing framework

# Source dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Load Fish functions for testing
load_fish_function() {
  local function_name="$1"
  local fish_function_file="$DOTFILES_DIR/fish/.config/fish/functions/${function_name}.fish"
  
  if [ -f "$fish_function_file" ]; then
    # Convert Fish function syntax to bash-compatible for testing
    # This is a simplified approach - we'll execute fish commands via fish shell
    export FISH_FUNCTION_FILE="$fish_function_file"
    return 0
  else
    return 1
  fi
}

# Execute Fish function in fish shell
run_fish_function() {
  local function_name="$1"
  shift
  local args="$@"
  
  if load_fish_function "$function_name"; then
    # Source the fish function and execute it
    fish -c "source '$FISH_FUNCTION_FILE'; $function_name $args" 2>&1
  else
    echo "Fish function $function_name not found"
    return 1
  fi
}

# Load Zsh functions for testing
load_zsh_functions() {
  local zsh_functions_file="$DOTFILES_DIR/zsh/.config/zsh/functions.zsh"
  
  if [ -f "$zsh_functions_file" ]; then
    # Source the Zsh functions in current bash session
    # We'll need to adapt Zsh syntax to bash where needed
    source "$zsh_functions_file" 2>/dev/null || true
    return 0
  else
    return 1
  fi
}

# Execute Zsh function
run_zsh_function() {
  local function_name="$1"
  shift
  local args="$@"
  
  if load_zsh_functions; then
    # Execute the function if it's available
    if command -v "$function_name" >/dev/null 2>&1; then
      "$function_name" "$@" 2>&1
    else
      echo "Zsh function $function_name not found"
      return 1
    fi
  else
    echo "Failed to load Zsh functions"
    return 1
  fi
}

# Test abbreviation expansion
test_abbreviation() {
  local abbr="$1"
  local expected="$2"
  local shell_type="${3:-both}"
  
  case "$shell_type" in
    "fish")
      test_fish_abbreviation "$abbr" "$expected"
      ;;
    "zsh")
      test_zsh_abbreviation "$abbr" "$expected"
      ;;
    "both")
      test_fish_abbreviation "$abbr" "$expected" &&
      test_zsh_abbreviation "$abbr" "$expected"
      ;;
    *)
      echo "Unknown shell type: $shell_type"
      return 1
      ;;
  esac
}

# Test Fish abbreviation expansion
test_fish_abbreviation() {
  local abbr="$1"
  local expected="$2"
  
  # Load Fish abbreviations file
  local fish_abbr_file="$DOTFILES_DIR/fish/.config/fish/abbreviations.fish"
  
  if [ -f "$fish_abbr_file" ]; then
    # Extract the abbreviation expansion from the Fish file
    # Format: abbr -a -g abbr_name 'expansion'
    local actual=$(grep "^abbr -a -g $abbr " "$fish_abbr_file" | sed "s/^abbr -a -g $abbr '//" | sed "s/'$//" 2>/dev/null)
    
    if [ "$actual" = "$expected" ]; then
      return 0
    else
      echo "Fish abbreviation mismatch: '$abbr' -> '$actual' (expected: '$expected')"
      return 1
    fi
  else
    echo "Fish abbreviations file not found"
    return 1
  fi
}

# Test Zsh abbreviation expansion
test_zsh_abbreviation() {
  local abbr="$1"
  local expected="$2"
  
  # Load Zsh abbreviations file
  local zsh_abbr_file="$DOTFILES_DIR/zsh/.config/zsh-abbr/abbreviations.zsh"
  
  if [ -f "$zsh_abbr_file" ]; then
    # Extract the abbreviation expansion from the Zsh file
    # Format: abbr "abbr_name"="expansion"
    local actual=$(grep "^abbr \"$abbr\"=" "$zsh_abbr_file" | cut -d'"' -f4 2>/dev/null)
    
    if [ "$actual" = "$expected" ]; then
      return 0
    else
      echo "Zsh abbreviation mismatch: '$abbr' -> '$actual' (expected: '$expected')"
      return 1
    fi
  else
    echo "Zsh abbreviations file not found"
    return 1
  fi
}

# Load environment variables
load_environment() {
  local env_file="$DOTFILES_DIR/shared/environment.sh"
  
  if [ -f "$env_file" ]; then
    source "$env_file"
    return 0
  else
    return 1
  fi
}

# Test if command exists in PATH
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Test if function is available
function_exists() {
  [ "$(type -t "$1")" = "function" ]
}

# Setup PATH with dotfiles bin directory
setup_dotfiles_path() {
  export PATH="$DOTFILES_DIR/bin/.local/bin:$PATH"
}

# Restore original PATH
restore_path() {
  if [ -n "$ORIGINAL_PATH" ]; then
    export PATH="$ORIGINAL_PATH"
  fi
}

# Save original PATH
save_original_path() {
  export ORIGINAL_PATH="$PATH"
}