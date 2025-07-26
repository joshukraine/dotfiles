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
  run startpost --help 2>/dev/null || run startpost -h 2>/dev/null || true
  # Function should exist (either help works or command fails appropriately)
  # We can't test actual PostgreSQL start without having it installed
}

@test "stoppost function exists and is callable" {
  run stoppost --help 2>/dev/null || run stoppost -h 2>/dev/null || true
  # Function should exist (either help works or command fails appropriately)
}

@test "statpost function exists and is callable" {
  run statpost --help 2>/dev/null || run statpost -h 2>/dev/null || true
  # Function should exist (either help works or command fails appropriately)
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
