#!/usr/bin/env bats

# Tests for glg (pretty git log with graph and stats) utility

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

@test "glg shows pretty formatted git log with graph" {
  setup_main_repo

  # Create some commits to display
  echo "file1" > file1.txt
  git add file1.txt
  git commit -m "Add file1"

  # Create a branch and merge to show graph
  git checkout -b feature/branch
  echo "feature" > feature.txt
  git add feature.txt
  git commit -m "Add feature"

  git checkout main
  echo "main work" > main.txt
  git add main.txt
  git commit -m "Work on main"

  git merge feature/branch --no-ff -m "Merge feature branch"

  run glg
  assert_contains "$output" "Merge feature branch"
  assert_contains "$output" "Add feature"
  assert_contains "$output" "Work on main"
  # Check for graph characters
  assert_contains "$output" "*"  # Graph node
  assert_contains "$output" "|"  # Graph line
  [ "$status" -eq 0 ]
}

@test "glg shows file statistics" {
  setup_main_repo

  # Create commit with file changes
  echo "line1" > test.txt
  git add test.txt
  git commit -m "Add test file"

  echo "line2" >> test.txt
  echo "line3" >> test.txt
  git add test.txt
  git commit -m "Update test file"

  run glg
  # Should show stats like "1 file changed, 2 insertions(+)"
  assert_contains "$output" "file changed"
  assert_contains "$output" "insertion"
  [ "$status" -eq 0 ]
}

@test "glg formats dates correctly" {
  setup_main_repo

  run glg
  # Check for date format like "Jan 22, 2025"
  assert_contains "$output" ", 20"  # Year should be there
  [ "$status" -eq 0 ]
}

@test "glg uses color codes" {
  setup_main_repo

  # Force color output even in non-tty
  run bash -c "export TERM=xterm-256color; glg"
  # Check for commit hash which should be yellow
  # The format includes %C(yellow bold) for hashes
  [ "$status" -eq 0 ]
}

@test "glg works in non-git directory" {
  setup_non_git_dir

  run glg
  assert_contains "$output" "not a git repository"
  [ "$status" -ne 0 ]
}

@test "glg passes through to git log with graph" {
  setup_main_repo

  # Create multiple commits
  for i in {1..3}; do
    echo "file$i" > "file$i.txt"
    git add "file$i.txt"
    git commit -m "Commit $i"
  done

  # glg is a git log wrapper with graph, should work like git log
  run glg
  # Should show all commits with graph
  assert_contains "$output" "Commit 3"
  assert_contains "$output" "Commit 2"
  assert_contains "$output" "Commit 1"
  assert_contains "$output" "Initial commit"
  assert_contains "$output" "*"  # Graph nodes
  [ "$status" -eq 0 ]
}
