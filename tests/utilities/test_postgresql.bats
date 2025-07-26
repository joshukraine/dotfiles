#!/usr/bin/env bats
# shellcheck disable=SC2317

# Tests for PostgreSQL management utilities (startpost, stoppost, statpost)

load '../helpers/common.bash'
load '../helpers/shell_helpers.bash'

setup() {
  save_original_path
  setup_dotfiles_path
}

teardown() {
  restore_path
}

@test "startpost function exists and is callable" {
  # Test that the function is defined in the appropriate shell config
  local fish_func="${DOTFILES}/fish/.config/fish/functions/startpost.fish"
  local zsh_funcs="${DOTFILES}/zsh/.config/zsh/functions.zsh"

  # Function should exist in at least one shell configuration
  if [ -f "${fish_func}" ]; then
    assert_contains "$(cat "${fish_func}")" "function startpost"
  elif [ -f "${zsh_funcs}" ] && grep -q "startpost" "${zsh_funcs}"; then
    assert_contains "$(grep -A5 -B5 startpost "${zsh_funcs}")" "startpost"
  else
    fail "startpost function not found in Fish or Zsh configurations"
  fi
}

@test "stoppost function exists and is callable" {
  # Test that the function is defined in the appropriate shell config
  local fish_func="${DOTFILES}/fish/.config/fish/functions/stoppost.fish"
  local zsh_funcs="${DOTFILES}/zsh/.config/zsh/functions.zsh"

  # Function should exist in at least one shell configuration
  if [ -f "${fish_func}" ]; then
    assert_contains "$(cat "${fish_func}")" "function stoppost"
  elif [ -f "${zsh_funcs}" ] && grep -q "stoppost" "${zsh_funcs}"; then
    assert_contains "$(grep -A5 -B5 stoppost "${zsh_funcs}")" "stoppost"
  else
    fail "stoppost function not found in Fish or Zsh configurations"
  fi
}

@test "statpost function exists and is callable" {
  # Test that the function is defined in the appropriate shell config
  local fish_func="${DOTFILES}/fish/.config/fish/functions/statpost.fish"
  local zsh_funcs="${DOTFILES}/zsh/.config/zsh/functions.zsh"

  # Function should exist in at least one shell configuration
  if [ -f "${fish_func}" ]; then
    assert_contains "$(cat "${fish_func}")" "function statpost"
  elif [ -f "${zsh_funcs}" ] && grep -q "statpost" "${zsh_funcs}"; then
    assert_contains "$(grep -A5 -B5 statpost "${zsh_funcs}")" "statpost"
  else
    fail "statpost function not found in Fish or Zsh configurations"
  fi
}

@test "startpost uses brew services" {
  # Load Zsh functions to make startpost available
  load_zsh_functions

  # Mock brew to test the command structure
  function brew() {
    echo "brew called with: $*"
  }
  export -f brew

  run startpost
  assert_contains "${output}" "brew"
  assert_contains "${output}" "services"
  assert_contains "${output}" "start"
  assert_contains "${output}" "postgresql"
  [ "${status}" -eq 0 ]
}

@test "stoppost uses brew services" {
  # Load Zsh functions to make stoppost available
  load_zsh_functions

  # Mock brew to test the command structure
  function brew() {
    echo "brew called with: $*"
  }
  export -f brew

  run stoppost
  assert_contains "${output}" "brew"
  assert_contains "${output}" "services"
  assert_contains "${output}" "stop"
  assert_contains "${output}" "postgresql"
  [ "${status}" -eq 0 ]
}

@test "statpost shows postgres processes" {
  # Load Zsh functions to make statpost available
  load_zsh_functions

  # Mock ps and rg to test the command structure
  function ps() {
    echo "postgres  1234  0.0  0.1  12345  6789 ??  S   12:00PM   0:01.23 postgres: server process"
    echo "postgres  1235  0.0  0.1  12345  6789 ??  S   12:00PM   0:01.23 postgres: background writer"
  }
  function rg() {
    echo "postgres  1234  0.0  0.1  12345  6789 ??  S   12:00PM   0:01.23 postgres: server process"
    echo "postgres  1235  0.0  0.1  12345  6789 ??  S   12:00PM   0:01.23 postgres: background writer"
  }
  export -f ps rg

  run statpost
  assert_contains "${output}" "postgres"
  [ "${status}" -eq 0 ]
}

@test "PostgreSQL functions work in Zsh shell" {
  # Source the Zsh functions and test availability
  source "${HOME}/dotfiles/zsh/.config/zsh/functions.zsh"

  run type startpost
  [ "${status}" -eq 0 ]

  run type stoppost
  [ "${status}" -eq 0 ]

  run type statpost
  [ "${status}" -eq 0 ]
}

@test "PostgreSQL functions work in Fish shell" {
  # Test that the functions are available in Fish context
  if command -v fish >/dev/null 2>&1; then
    run fish -c "type startpost"
    [ "${status}" -eq 0 ]

    run fish -c "type stoppost"
    [ "${status}" -eq 0 ]

    run fish -c "type statpost"
    [ "${status}" -eq 0 ]
  else
    skip "Fish shell not available"
  fi
}

@test "PostgreSQL functions have consistent naming" {
  # Load Zsh functions to make PostgreSQL functions available
  load_zsh_functions

  # All three functions should exist
  run type startpost
  [ "${status}" -eq 0 ]

  run type stoppost
  [ "${status}" -eq 0 ]

  run type statpost
  [ "${status}" -eq 0 ]
}

@test "PostgreSQL functions are properly scoped" {
  # Load Zsh functions to make PostgreSQL functions available
  load_zsh_functions

  # Functions should be available as functions, not aliases or commands
  run type -t startpost
  assert_contains "${output}" "function"
  [ "${status}" -eq 0 ]
}
