#!/usr/bin/env bats

# Tests for g (smart git wrapper) utility

load '../helpers/common.bash'
load '../helpers/git_helpers.bash'
load '../helpers/shell_helpers.bash'

setup() {
  save_original_path
  setup_dotfiles_path
}

teardown() {
  teardown_test_git_repo
  restore_path
}

@test "g with no arguments shows git status" {
  setup_main_repo

  # Make some changes to have status output
  echo "test file" >test.txt
  git add test.txt
  echo "modified" >>README.md

  run g
  # Check for branch name - could be main or master depending on git version/config
  if [[ "${output}" == *"## main"* ]]; then
    assert_contains "${output}" "## main"
  elif [[ "${output}" == *"## master"* ]]; then
    assert_contains "${output}" "## master"
  else
    echo "Expected branch name (main or master) not found in output: ${output}"
    return 1
  fi
  assert_contains "${output}" "A  test.txt"  # Added file
  assert_contains "${output}" " M README.md" # Modified file
  [ "${status}" -eq 0 ]
}

@test "g with no arguments clears terminal first" {
  # Check that the g script contains the clear command
  run grep -q "clear" "${DOTFILES_DIR}/bin/.local/bin/g"
  [ "${status}" -eq 0 ]
}

@test "g with arguments passes through to git" {
  setup_main_repo

  run g log --oneline -n 1
  assert_contains "${output}" "Initial commit"
  [ "${status}" -eq 0 ]
}

@test "g handles git command failures" {
  setup_main_repo

  run g invalid-command
  assert_contains "${output}" "invalid-command"
  [ "${status}" -ne 0 ]
}

@test "g works in non-git directories" {
  setup_non_git_dir

  run g
  assert_contains "${output}" "not a git repository"
  [ "${status}" -ne 0 ]
}

@test "g passes multiple arguments correctly" {
  setup_main_repo

  # Create a commit to test against
  echo "test" >file.txt
  git add file.txt
  git commit -m "Add test file"

  run g show --name-only HEAD
  assert_contains "${output}" "Add test file"
  assert_contains "${output}" "file.txt"
  [ "${status}" -eq 0 ]
}

@test "g preserves git exit codes" {
  setup_main_repo

  # Force a git error
  run g checkout non-existent-branch
  [ "${status}" -eq 1 ] # Git returns 1 for checkout errors
}
