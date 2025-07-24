#!/usr/bin/env bats

# Tests for gpum (git push upstream) function

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

@test "gpum shows help message with -h flag" {
  setup_test_git_repo

  run run_fish_function gpum -h
  assert_contains "${output}" "Usage: gpum"
  assert_contains "${output}" "Push current branch to origin with upstream tracking"
  [ "${status}" -eq 0 ]
}

@test "gpum shows help message with --help flag" {
  setup_test_git_repo

  run run_fish_function gpum --help
  assert_contains "${output}" "Usage: gpum"
  assert_contains "${output}" "Push current branch to origin with upstream tracking"
  [ "${status}" -eq 0 ]
}

@test "gpum fails in non-git directory" {
  setup_non_git_dir

  run run_fish_function gpum
  assert_contains "${output}" "Not a git repository"
  [ "${status}" -eq 1 ]
}

@test "gpum fails when no origin remote exists" {
  setup_no_remote_repo
  create_feature_branch "test-branch"

  run run_fish_function gpum
  assert_contains "${output}" "No 'origin' remote found"
  [ "${status}" -eq 1 ]
}

@test "gpum successfully pushes feature branch in main-based repository" {
  setup_main_repo
  create_feature_branch "feature/awesome-feature"

  run run_fish_function gpum
  assert_contains "${output}" "Pushing feature/awesome-feature to origin"
  assert_contains "${output}" "Successfully pushed"
  assert_contains "${output}" "default branch: main"
  [ "${status}" -eq 0 ]
}

@test "gpum successfully pushes feature branch in master-based repository" {
  setup_master_repo
  create_feature_branch "feature/legacy-feature"

  run run_fish_function gpum
  assert_contains "${output}" "Pushing feature/legacy-feature to origin"
  assert_contains "${output}" "Successfully pushed"
  assert_contains "${output}" "default branch: master"
  [ "${status}" -eq 0 ]
}

@test "gpum handles detached HEAD state" {
  setup_main_repo
  # Create detached HEAD
  git checkout HEAD~0

  run run_fish_function gpum
  assert_contains "${output}" "Could not determine current branch"
  [ "${status}" -eq 1 ]
}

@test "gpum works from main branch" {
  setup_main_repo

  # Should work even from main branch
  run run_fish_function gpum
  assert_contains "${output}" "Successfully pushed"
  [ "${status}" -eq 0 ]
}

@test "gpum works from master branch" {
  setup_master_repo

  # Should work even from master branch
  run run_fish_function gpum
  assert_contains "${output}" "Successfully pushed"
  [ "${status}" -eq 0 ]
}

@test "gpum detects default branch correctly when remote has main" {
  setup_main_repo
  create_feature_branch "test-feature"

  run run_fish_function gpum
  assert_contains "${output}" "default branch: main"
  [ "${status}" -eq 0 ]
}

@test "gpum detects default branch correctly when remote has master" {
  setup_master_repo
  create_feature_branch "test-feature"

  run run_fish_function gpum
  assert_contains "${output}" "default branch: master"
  [ "${status}" -eq 0 ]
}

@test "gpum sets upstream tracking correctly" {
  setup_main_repo
  create_feature_branch "tracking-test"

  run run_fish_function gpum
  [ "${status}" -eq 0 ]

  # Verify upstream is set
  local upstream
  upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null)
  assert_equals "origin/tracking-test" "${upstream}"
}
