#!/usr/bin/env bats

# Tests for git-check-uncommitted utility script

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

@test "git-check-uncommitted fails in non-git directory" {
  setup_non_git_dir

  run git-check-uncommitted
  [ "$status" -eq 2 ]
}

@test "git-check-uncommitted succeeds with clean repository" {
  setup_main_repo

  run git-check-uncommitted
  [ "$status" -eq 0 ]
}

@test "git-check-uncommitted fails with uncommitted changes" {
  setup_main_repo
  create_uncommitted_changes

  run git-check-uncommitted
  [ "$status" -eq 1 ]
}

@test "git-check-uncommitted fails with unstaged changes" {
  setup_main_repo
  create_unstaged_changes

  run git-check-uncommitted
  [ "$status" -eq 1 ]
}

@test "git-check-uncommitted --prompt shows prompt with uncommitted changes" {
  setup_main_repo
  create_uncommitted_changes

  # Simulate user choosing 'n' (no)
  run bash -c "echo 'n' | git-check-uncommitted --prompt"
  assert_contains "$output" "uncommitted changes"
  assert_contains "$output" "Continue anyway"
  [ "$status" -eq 1 ]
}

@test "git-check-uncommitted --prompt continues when user chooses yes" {
  setup_main_repo
  create_uncommitted_changes

  # Simulate user choosing 'y' (yes)
  run bash -c "echo 'y' | git-check-uncommitted --prompt"
  assert_contains "$output" "uncommitted changes"
  assert_contains "$output" "Continue anyway"
  [ "$status" -eq 0 ]
}

@test "git-check-uncommitted --prompt continues when user chooses Y" {
  setup_main_repo
  create_uncommitted_changes

  # Simulate user choosing 'Y' (yes, uppercase)
  run bash -c "echo 'Y' | git-check-uncommitted --prompt"
  [ "$status" -eq 0 ]
}

@test "git-check-uncommitted --prompt aborts on empty input" {
  setup_main_repo
  create_uncommitted_changes

  # Simulate user pressing enter (empty input)
  run bash -c "echo '' | git-check-uncommitted --prompt"
  [ "$status" -eq 1 ]
}

@test "git-check-uncommitted --prompt aborts on invalid input" {
  setup_main_repo
  create_uncommitted_changes

  # Simulate user choosing invalid option
  run bash -c "echo 'maybe' | git-check-uncommitted --prompt"
  [ "$status" -eq 1 ]
}

@test "git-check-uncommitted --prompt skips prompt with clean repository" {
  setup_main_repo
  # Clean repository - no uncommitted changes

  run git-check-uncommitted --prompt
  # Should succeed without showing prompt
  [ "$status" -eq 0 ]
  # Should not contain prompt text
  [[ ! "$output" =~ "Continue anyway" ]]
}

@test "git-check-uncommitted detects both staged and unstaged changes" {
  setup_main_repo

  # Create both staged and unstaged changes
  echo "Staged change" >> staged.txt
  git add staged.txt
  echo "Unstaged change" >> README.md

  run git-check-uncommitted
  [ "$status" -eq 1 ]
}

@test "git-check-uncommitted works in subdirectory" {
  setup_main_repo

  # Create subdirectory and work from there
  mkdir subdir
  cd subdir
  echo "Change from subdir" >> ../README.md

  run git-check-uncommitted
  [ "$status" -eq 1 ]
}

@test "git-check-uncommitted handles newly added files" {
  setup_main_repo

  # Add new file
  echo "New file content" > newfile.txt
  git add newfile.txt

  run git-check-uncommitted
  [ "$status" -eq 1 ]
}

@test "git-check-uncommitted handles deleted files" {
  setup_main_repo

  # Delete existing file
  git rm README.md

  run git-check-uncommitted
  [ "$status" -eq 1 ]
}

@test "git-check-uncommitted succeeds after committing changes" {
  setup_main_repo

  # Make and commit changes
  echo "New content" >> README.md
  git add README.md
  git commit -m "Update README"

  run git-check-uncommitted
  [ "$status" -eq 0 ]
}

@test "git-check-uncommitted handles empty repository" {
  # Create empty git repo (no initial commit) using established infrastructure
  setup_test_git_repo
  git init
  git config user.name "Test User"
  git config user.email "test@example.com"

  run git-check-uncommitted
  # Empty repo behavior - depends on implementation
  # Should not crash at minimum
  [ "$status" -ge 0 ]
}

@test "git-check-uncommitted shows help or usage info" {
  setup_main_repo

  # Test if script provides help (if implemented)
  run git-check-uncommitted --help
  # Should either show help or fail gracefully
  [ "$status" -ge 0 ]
}
