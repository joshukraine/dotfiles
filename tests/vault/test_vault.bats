#!/usr/bin/env bats

# Tests for vault, the Obsidian-lane launcher.
#
# These cover lane discovery and resolution against a fixture vault. Every
# case either resolves or refuses before the fzf picker, so neither fzf nor
# tmuxinator is needed, and nothing touches the real vault or tmux.
#
# vault is sourced in a subshell rather than by bats directly, because it sets
# -euo pipefail for its own use and that should not leak into the test runner.

load '../helpers/common.bash'
load '../helpers/shell_helpers.bash'

setup() {
  VAULT_BIN="${DOTFILES}/bin/.local/bin/vault"
  require_file "${VAULT_BIN}"

  FIXTURE="$(mktemp -d)"
  mkdir -p \
    "${FIXTURE}/Bible Teaching/romans-session-7" \
    "${FIXTURE}/Developer/archive" \
    "${FIXTURE}/Developer/hermes/too-deep" \
    "${FIXTURE}/Health/archive" \
    "${FIXTURE}/.obsidian/plugins"
  export OBSIDIAN_VAULT="${FIXTURE}"

  EXPECTED_LANES="$(printf '%s\n' \
    "Bible Teaching" \
    "Bible Teaching/romans-session-7" \
    "Developer" \
    "Developer/archive" \
    "Developer/hermes" \
    "Health" \
    "Health/archive")"
}

teardown() {
  if [ -n "${FIXTURE}" ] && [ -d "${FIXTURE}" ]; then
    rm -rf "${FIXTURE}"
  fi
}

# Run one of vault's functions in a subshell and capture its output.
run_vault() {
  run bash -c "source '${VAULT_BIN}' && $*"
}

@test "lanes lists folders up to two levels deep, sorted" {
  run_vault lanes
  [ "${status}" -eq 0 ]
  [ "${output}" = "${EXPECTED_LANES}" ]
}

@test "lanes skips dot-folders and anything deeper than two levels" {
  run_vault lanes
  [[ "${output}" != *".obsidian"* ]]
  [[ "${output}" != *"too-deep"* ]]
}

@test "--list prints the same lanes through the CLI entry point" {
  run "${VAULT_BIN}" --list
  [ "${status}" -eq 0 ]
  [ "${output}" = "${EXPECTED_LANES}" ]
}

@test "an exact relative path resolves as given" {
  run_vault resolve_lane "'Bible Teaching/romans-session-7'"
  [ "${status}" -eq 0 ]
  [ "${output}" = "Bible Teaching/romans-session-7" ]
}

@test "a trailing slash is tolerated" {
  run_vault resolve_lane "Developer/hermes/"
  [ "${status}" -eq 0 ]
  [ "${output}" = "Developer/hermes" ]
}

@test "a unique folder name resolves to its path, case-insensitively" {
  run_vault resolve_lane HERMES
  [ "${status}" -eq 0 ]
  [ "${output}" = "Developer/hermes" ]
}

@test "a folder that does not exist is refused, pointing at Obsidian" {
  run_vault resolve_lane nope
  [ "${status}" -eq 1 ]
  [[ "${output}" == *"no folder matching 'nope'"* ]]
  [[ "${output}" == *"Create the folder in Obsidian first"* ]]
}

@test "--help prints the header comment" {
  run "${VAULT_BIN}" --help
  [ "${status}" -eq 0 ]
  [[ "${lines[0]}" == "Open a tmux session for one lane of the Obsidian vault" ]]
  [[ "${output}" == *"OBSIDIAN_VAULT"* ]]
}
