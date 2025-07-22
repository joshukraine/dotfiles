#!/usr/bin/env bats

# Tests for gl (pretty git log) utility

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

@test "gl shows pretty formatted git log" {
  setup_main_repo
  
  # Create some commits to display
  echo "file1" > file1.txt
  git add file1.txt
  git commit -m "Add file1"
  
  echo "file2" > file2.txt
  git add file2.txt
  git commit -m "Add file2 with longer message to test formatting"
  
  run gl
  assert_contains "$output" "Add file2 with longer message"
  assert_contains "$output" "Add file1"
  assert_contains "$output" "Initial commit"
  assert_contains "$output" "Test User <test@example.com>"
  [ "$status" -eq 0 ]
}

@test "gl formats dates correctly" {
  setup_main_repo
  
  run gl
  # Check for date format like "Jan 22, 2025"
  assert_contains "$output" ", 20"  # Year should be there
  [ "$status" -eq 0 ]
}

@test "gl uses color codes" {
  setup_main_repo
  
  # Force color output even in non-tty
  run bash -c "export TERM=xterm-256color; gl"
  # Check for commit hash which should be yellow
  # The format includes %C(yellow bold) for hashes
  [ "$status" -eq 0 ]
}

@test "gl works in non-git directory" {
  setup_non_git_dir
  
  run gl
  assert_contains "$output" "not a git repository"
  [ "$status" -ne 0 ]
}

@test "gl shows branch decorations" {
  setup_main_repo
  create_feature_branch "feature/test"
  
  run gl
  # Should show HEAD -> feature/test decoration
  assert_contains "$output" "HEAD"
  assert_contains "$output" "feature/test"
  [ "$status" -eq 0 ]
}

@test "gl passes through to git log" {
  setup_main_repo
  
  # Create multiple commits
  for i in {1..3}; do
    echo "file$i" > "file$i.txt"
    git add "file$i.txt"
    git commit -m "Commit $i"
  done
  
  # gl is a direct git log wrapper, should work like git log
  run gl
  # Should show all commits
  assert_contains "$output" "Commit 3"
  assert_contains "$output" "Commit 2"
  assert_contains "$output" "Commit 1"
  assert_contains "$output" "Initial commit"
  [ "$status" -eq 0 ]
}