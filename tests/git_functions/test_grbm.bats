#!/usr/bin/env bats

# Tests for grbm (git rebase main/master) function

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

@test "grbm shows help message with -h flag" {
  setup_test_git_repo
  
  run run_fish_function grbm -h
  assert_contains "$output" "Usage: grbm"
  assert_contains "$output" "Rebase current branch against the default branch"
  [ "$status" -eq 0 ]
}

@test "grbm shows help message with --help flag" {
  setup_test_git_repo
  
  run run_fish_function grbm --help
  assert_contains "$output" "Usage: grbm"
  assert_contains "$output" "Rebase current branch against the default branch"
  [ "$status" -eq 0 ]
}

@test "grbm fails in non-git directory" {
  setup_non_git_dir
  
  run run_fish_function grbm
  assert_contains "$output" "Not a git repository"
  [ "$status" -eq 1 ]
}

@test "grbm fails when no origin remote exists" {
  setup_no_remote_repo
  create_feature_branch "test-branch"
  
  run run_fish_function grbm
  assert_contains "$output" "No 'origin' remote found. Cannot rebase against remote branch."
  [ "$status" -eq 1 ]
}

@test "grbm fails when uncommitted changes exist" {
  setup_main_repo
  create_feature_branch "feature/test"
  create_uncommitted_changes
  
  # When running grbm, git-check-uncommitted --prompt will detect changes
  # and the test will provide "n" as input to abort
  run bash -c "echo 'n' | fish --no-config -c \"source '$DOTFILES_DIR/fish/.config/fish/functions/grbm.fish'; function git-check-uncommitted; '$DOTFILES_DIR/bin/.local/bin/git-check-uncommitted' \\\$argv; end; grbm\""
  assert_contains "$output" "Warning: You have uncommitted changes"
  [ "$status" -eq 1 ]
}

@test "grbm fails even when user continues with uncommitted changes" {
  setup_main_repo
  create_feature_branch "feature/test"
  create_uncommitted_changes
  
  # When running grbm, git-check-uncommitted --prompt will detect changes
  # and the test will provide "y" as input to continue, but git rebase will still fail
  run bash -c "echo 'y' | fish --no-config -c \"source '$DOTFILES_DIR/fish/.config/fish/functions/grbm.fish'; function git-check-uncommitted; '$DOTFILES_DIR/bin/.local/bin/git-check-uncommitted' \\\$argv; end; grbm\""
  assert_contains "$output" "Rebase failed. You may need to resolve conflicts manually."
  [ "$status" -eq 1 ]
}

@test "grbm skips rebase when already on default branch (main)" {
  setup_main_repo
  # Already on main branch
  
  run run_fish_function grbm
  assert_contains "$output" "Already on default branch"
  [ "$status" -eq 0 ]
}

@test "grbm skips rebase when already on default branch (master)" {
  setup_master_repo
  # Already on master branch
  
  run run_fish_function grbm
  assert_contains "$output" "Already on default branch"
  [ "$status" -eq 0 ]
}

@test "grbm successfully rebases feature branch on main" {
  setup_main_repo
  create_feature_branch "feature/awesome"
  
  # Add a commit to main to create something to rebase against
  git checkout main
  echo "New main content" >> main-file.txt
  git add main-file.txt
  git commit -m "Update main"
  git push origin main
  git checkout feature/awesome
  
  run run_fish_function grbm
  assert_contains "$output" "Rebasing feature/awesome against"
  assert_contains "$output" "origin/main"
  [ "$status" -eq 0 ]
}

@test "grbm successfully rebases feature branch on master" {
  setup_master_repo
  create_feature_branch "feature/legacy"
  
  # Add a commit to master to create something to rebase against
  git checkout master
  echo "New master content" >> master-file.txt
  git add master-file.txt
  git commit -m "Update master"
  git push origin master
  git checkout feature/legacy
  
  run run_fish_function grbm
  assert_contains "$output" "Rebasing feature/legacy against"
  assert_contains "$output" "origin/master"
  [ "$status" -eq 0 ]
}

@test "grbm detects default branch correctly when remote has main" {
  setup_main_repo
  create_feature_branch "test-feature"
  
  run run_fish_function grbm
  assert_contains "$output" "origin/main"
  [ "$status" -eq 0 ]
}

@test "grbm detects default branch correctly when remote has master" {
  setup_master_repo
  create_feature_branch "test-feature"
  
  run run_fish_function grbm
  assert_contains "$output" "origin/master"
  [ "$status" -eq 0 ]
}

@test "grbm handles fetch failure gracefully" {
  setup_main_repo
  create_feature_branch "test-feature"
  
  # Remove remote to simulate fetch failure
  git remote remove origin
  git remote add origin /nonexistent/repo
  
  run run_fish_function grbm
  assert_contains "$output" "Failed to fetch from origin"
  [ "$status" -eq 1 ]
}

@test "grbm handles detached HEAD state" {
  setup_main_repo
  # Create detached HEAD
  git checkout HEAD~0
  
  run run_fish_function grbm
  assert_contains "$output" "Could not determine current branch"
  [ "$status" -eq 1 ]
}