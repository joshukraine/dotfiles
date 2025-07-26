#!/usr/bin/env bats
# shellcheck disable=SC2317
bats_require_minimum_version 1.5.0

# Tests for Finder utilities (haf, saf)

load '../helpers/common.bash'
load '../helpers/shell_helpers.bash'

setup() {
  save_original_path
  setup_dotfiles_path
}

teardown() {
  restore_path
}

@test "haf function exists and is callable" {
  # Load Zsh functions to make haf available
  load_zsh_functions
  run type haf
  [ "${status}" -eq 0 ]
}

@test "saf function exists and is callable" {
  # Load Zsh functions to make saf available
  load_zsh_functions
  run type saf
  [ "${status}" -eq 0 ]
}

@test "haf uses defaults write command" {
  # Load Zsh functions to make haf available
  load_zsh_functions

  # Mock defaults and killall to test the command structure
  function defaults() {
    echo "defaults called with: $*"
  }
  function killall() {
    echo "killall called with: $*"
  }
  export -f defaults killall

  run haf
  assert_contains "${output}" "defaults"
  assert_contains "${output}" "write"
  assert_contains "${output}" "com.apple.finder"
  assert_contains "${output}" "AppleShowAllFiles"
  assert_contains "${output}" "FALSE"
  assert_contains "${output}" "killall"
  assert_contains "${output}" "Finder"
  [ "${status}" -eq 0 ]
}

@test "saf uses defaults write command" {
  # Load Zsh functions to make saf available
  load_zsh_functions

  # Mock defaults and killall to test the command structure
  function defaults() {
    echo "defaults called with: $*"
  }
  function killall() {
    echo "killall called with: $*"
  }
  export -f defaults killall

  run saf
  assert_contains "${output}" "defaults"
  assert_contains "${output}" "write"
  assert_contains "${output}" "com.apple.finder"
  assert_contains "${output}" "AppleShowAllFiles"
  assert_contains "${output}" "TRUE"
  assert_contains "${output}" "killall"
  assert_contains "${output}" "Finder"
  [ "${status}" -eq 0 ]
}

@test "haf and saf use opposite boolean values" {
  # Load Zsh functions to make haf and saf available
  load_zsh_functions

  # Mock functions to capture the calls
  function defaults() {
    echo "defaults: $*"
  }
  function killall() {
    echo "killall: $*"
  }
  export -f defaults killall

  # Test haf (hide all files - should use FALSE)
  run haf
  assert_contains "${output}" "FALSE"
  assert_not_contains "${output}" "TRUE"

  # Test saf (show all files - should use TRUE)
  run saf
  assert_contains "${output}" "TRUE"
  assert_not_contains "${output}" "FALSE"
}

@test "Finder functions work in Zsh shell" {
  # Source the Zsh functions and test availability
  source "${HOME}/dotfiles/zsh/.config/zsh/functions.zsh"

  run type haf
  [ "${status}" -eq 0 ]

  run type saf
  [ "${status}" -eq 0 ]
}

@test "Finder functions work in Fish shell" {
  # Test that the functions are available in Fish context
  if command -v fish >/dev/null 2>&1; then
    run fish -c "type haf"
    [ "${status}" -eq 0 ]

    run fish -c "type saf"
    [ "${status}" -eq 0 ]
  else
    skip "Fish shell not available"
  fi
}

@test "Finder functions have consistent naming" {
  # Load Zsh functions to make them available
  load_zsh_functions

  # Both functions should exist
  run type haf
  [ "${status}" -eq 0 ]

  run type saf
  [ "${status}" -eq 0 ]
}

@test "Finder functions are properly scoped" {
  # Load Zsh functions to make them available
  load_zsh_functions

  # Functions should be available as functions, not aliases or commands
  run type -t haf
  assert_contains "${output}" "function"
  [ "${status}" -eq 0 ]
}

@test "Finder functions include helpful comments" {
  # Check that the Fish function files include the GUI shortcut comment
  if [ -f "${HOME}/dotfiles/fish/.config/fish/functions/haf.fish" ]; then
    run cat "${HOME}/dotfiles/fish/.config/fish/functions/haf.fish"
    assert_contains "${output}" "Cmd + Shift + ."
    [ "${status}" -eq 0 ]
  fi
}

@test "Finder functions work on macOS" {
  # Only run on macOS
  if [ "$(uname)" != "Darwin" ]; then
    skip "Finder functions are macOS-specific"
  fi

  # Load Zsh functions to make them available
  load_zsh_functions

  # Test that the functions exist and can be called
  run type haf
  [ "${status}" -eq 0 ]

  run type saf
  [ "${status}" -eq 0 ]
}
