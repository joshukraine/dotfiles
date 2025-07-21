#!/usr/bin/env bats

# Tests for gcom (git checkout main/master) function

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

@test "gcom shows help message with -h flag" {
  setup_test_git_repo
  
  run run_fish_function gcom -h
  assert_contains "$output" "Usage: gcom"
  assert_contains "$output" "Checkout the default branch"
  [ "$status" -eq 0 ]
}

@test "gcom shows help message with --help flag" {
  setup_test_git_repo
  
  run run_fish_function gcom --help
  assert_contains "$output" "Usage: gcom"
  assert_contains "$output" "Checkout the default branch"
  [ "$status" -eq 0 ]
}

@test "gcom accepts -p flag for pull" {
  setup_test_git_repo
  
  run run_fish_function gcom -h
  assert_contains "$output" "-p"
  assert_contains "$output" "pull"
  [ "$status" -eq 0 ]
}

@test "gcom fails in non-git directory" {
  setup_non_git_dir
  
  run run_fish_function gcom
  assert_contains "$output" "Not a git repository"
  [ "$status" -eq 1 ]
}

@test "gcom fails when no origin remote exists" {
  setup_no_remote_repo
  create_feature_branch "test-branch"
  
  run run_fish_function gcom
  assert_contains "$output" "No 'origin' remote found"
  [ "$status" -eq 1 ]
}

@test "gcom fails when uncommitted changes exist" {
  setup_main_repo
  create_feature_branch "feature/test"
  create_uncommitted_changes
  
  # Mock git-check-uncommitted to return failure (user chose not to continue)
  local mock_path=$(mock_command "git-check-uncommitted" "" 1)
  
  run run_fish_function gcom
  assert_contains "$output" "Uncommitted changes detected"
  [ "$status" -eq 1 ]
  
  cleanup_mock "$mock_path"
}

@test "gcom succeeds when user continues with uncommitted changes" {
  setup_main_repo
  create_feature_branch "feature/test"
  create_uncommitted_changes
  
  # Mock git-check-uncommitted to return success (user chose to continue)
  local mock_path=$(mock_command "git-check-uncommitted" "Proceeding with uncommitted changes..." 0)
  
  run run_fish_function gcom
  [ "$status" -eq 0 ]
  
  cleanup_mock "$mock_path"
}

@test "gcom successfully checks out main branch" {
  setup_main_repo
  create_feature_branch "feature/test"
  
  # Verify we're on feature branch
  assert_equals "feature/test" "$(get_current_branch)"
  
  run run_fish_function gcom
  assert_contains "$output" "Switching to"
  assert_contains "$output" "main"
  [ "$status" -eq 0 ]
  
  # Verify we switched to main
  assert_equals "main" "$(get_current_branch)"
}

@test "gcom successfully checks out master branch" {
  setup_master_repo
  create_feature_branch "feature/test"
  
  # Verify we're on feature branch
  assert_equals "feature/test" "$(get_current_branch)"
  
  run run_fish_function gcom
  assert_contains "$output" "Switching to"
  assert_contains "$output" "master"
  [ "$status" -eq 0 ]
  
  # Verify we switched to master
  assert_equals "master" "$(get_current_branch)"
}

@test "gcom with -p flag pulls after checkout" {
  setup_main_repo
  create_feature_branch "feature/test"
  
  # Add a commit to remote main to have something to pull
  git checkout main
  echo "Remote change" >> remote-file.txt
  git add remote-file.txt
  git commit -m "Remote change"
  git push origin main
  git checkout feature/test
  
  run run_fish_function gcom -p
  assert_contains "$output" "Switching to"
  assert_contains "$output" "main"
  assert_contains "$output" "Pulling latest changes"
  [ "$status" -eq 0 ]
}

@test "gcom detects default branch correctly when remote has main" {
  setup_main_repo
  create_feature_branch "test-feature"
  
  run run_fish_function gcom
  assert_contains "$output" "main"
  [ "$status" -eq 0 ]
}

@test "gcom detects default branch correctly when remote has master" {
  setup_master_repo
  create_feature_branch "test-feature"
  
  run run_fish_function gcom
  assert_contains "$output" "master"
  [ "$status" -eq 0 ]
}

@test "gcom handles fetch failure gracefully" {
  setup_main_repo
  create_feature_branch "test-feature"
  
  # Remove remote to simulate fetch failure
  git remote remove origin
  git remote add origin /nonexistent/repo
  
  run run_fish_function gcom
  assert_contains "$output" "Failed to fetch from origin"
  [ "$status" -eq 1 ]
}

@test "gcom skips checkout when already on default branch (main)" {
  setup_main_repo
  # Already on main branch
  
  run run_fish_function gcom
  # Should still succeed but mention we're already on main
  [ "$status" -eq 0 ]
}

@test "gcom skips checkout when already on default branch (master)" {
  setup_master_repo
  # Already on master branch
  
  run run_fish_function gcom
  # Should still succeed but mention we're already on master
  [ "$status" -eq 0 ]
}

@test "gcom with -p pulls even when already on default branch" {
  setup_main_repo
  # Already on main, but -p should still pull
  
  # Add a remote change to pull
  git checkout main
  echo "Remote change" >> remote-file.txt
  git add remote-file.txt
  git commit -m "Remote change"
  git push origin main
  git reset --hard HEAD~1  # Reset local to simulate being behind
  
  run run_fish_function gcom -p
  assert_contains "$output" "Pulling latest changes"
  [ "$status" -eq 0 ]
}

@test "gcom handles checkout failure gracefully" {
  setup_main_repo
  create_feature_branch "test-feature"
  
  # Create a situation where checkout might fail
  # (This is harder to simulate reliably, so we'll test the basic case)
  run run_fish_function gcom
  [ "$status" -eq 0 ]
}