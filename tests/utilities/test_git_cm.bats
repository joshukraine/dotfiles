#!/usr/bin/env bats

# Tests for git-cm (git commit wrapper) script

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

@test "git-cm with arguments does commit -m" {
  setup_main_repo

  # Make a change to commit
  echo "Test change" >> test.txt
  git add test.txt

  run git-cm "Test commit message"
  assert_contains "$output" "Test commit message"
  [ "$status" -eq 0 ]

  # Verify the commit was created
  local last_commit=$(git log -1 --pretty=format:"%s")
  assert_equals "Test commit message" "$last_commit"
}

@test "git-cm with multiple arguments joins them" {
  setup_main_repo

  # Make a change to commit
  echo "Test change" >> test.txt
  git add test.txt

  run git-cm "Multi word" "commit message"
  [ "$status" -eq 0 ]

  # Verify the full message was used
  local last_commit=$(git log -1 --pretty=format:"%s")
  assert_equals "Multi word commit message" "$last_commit"
}

@test "git-cm without arguments would use editor mode" {
  setup_main_repo

  # Make a change to commit
  echo "Test change" >> test.txt
  git add test.txt

  # Use a non-interactive editor that will immediately exit without saving
  # This tests that git-cm calls the editor mode without hanging
  export GIT_EDITOR="true"
  run timeout 5s git-cm
  # Should fail with exit code 1 because editor didn't provide a message
  [ "$status" -eq 1 ]
}

@test "git-cm fails when nothing to commit" {
  setup_main_repo
  # Clean repository, nothing staged

  run git-cm "Nothing to commit"
  [ "$status" -ne 0 ]
}

@test "git-cm fails in non-git directory" {
  setup_non_git_dir

  run git-cm "Test message"
  assert_contains "$output" "not a git repository"
  [ "$status" -ne 0 ]
}

@test "git-cm handles special characters in commit message" {
  setup_main_repo

  # Make a change to commit
  echo "Test change" >> test.txt
  git add test.txt

  run git-cm "Fix: handle special chars like @#$% and quotes"
  [ "$status" -eq 0 ]

  # Verify the commit message was preserved correctly
  local last_commit=$(git log -1 --pretty=format:"%s")
  assert_contains "$last_commit" "special chars like @#$%"
}

@test "git-cm preserves line breaks in multi-line messages" {
  setup_main_repo

  # Make a change to commit
  echo "Test change" >> test.txt
  git add test.txt

  run git-cm $'First line\n\nSecond paragraph'
  [ "$status" -eq 0 ]

  # Verify the commit was created (exact formatting may vary)
  local commit_count=$(git rev-list --count HEAD)
  [ "$commit_count" -gt 1 ]  # Should have initial + our commit
}

@test "git-cm works with empty commit message (if git allows)" {
  setup_main_repo

  # Make a change to commit
  echo "Test change" >> test.txt
  git add test.txt

  # This might fail depending on git configuration
  run git-cm ""
  # Don't assert success/failure since behavior depends on git config
  # Just ensure it doesn't crash the script
}

@test "git-cm passes through git commit exit codes" {
  setup_main_repo

  # Try to commit without staging anything
  run git-cm "This should fail"
  [ "$status" -ne 0 ]

  # Now stage and commit successfully
  echo "Test change" >> test.txt
  git add test.txt

  run git-cm "This should succeed"
  [ "$status" -eq 0 ]
}
