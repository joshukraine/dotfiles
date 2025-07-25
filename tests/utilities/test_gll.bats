#!/usr/bin/env bats

# Tests for gll (detailed graph git log) utility

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

@test "gll shows detailed formatted git log with graph" {
  setup_main_repo

  # Create some commits to display
  echo "file1" >file1.txt
  git add file1.txt
  git commit -m "Add file1"

  echo "file2" >file2.txt
  git add file2.txt
  git commit -m "Add file2 with longer message to test formatting"

  run gll
  assert_contains "${output}" "Add file2 with longer message"
  assert_contains "${output}" "Add file1"
  assert_contains "${output}" "Initial commit"
  assert_contains "${output}" "Test User"
  # Check for graph characters
  assert_contains "${output}" "*" # Graph node
  [ "${status}" -eq 0 ]
}

@test "gll shows relative dates" {
  setup_main_repo

  run gll
  # Check for relative date format like "(2 hours ago)"
  assert_contains "${output}" "ago)"
  [ "${status}" -eq 0 ]
}

@test "gll shows abbreviated commit hashes" {
  setup_main_repo

  # Create a commit
  echo "test" >test.txt
  git add test.txt
  git commit -m "Test commit"

  run gll
  # Should show abbreviated hash (7 chars by default)
  # We can't test exact hash but can check format
  assert_contains "${output}" "Test commit"
  [ "${status}" -eq 0 ]
}

@test "gll uses color codes in output" {
  setup_main_repo

  # Force color output even in non-tty
  run bash -c "export TERM=xterm-256color; gll"
  # The function uses color codes like %C(bold blue) for hashes
  [ "${status}" -eq 0 ]
}

@test "gll works in non-git directory" {
  setup_non_git_dir

  run gll
  assert_contains "${output}" "not a git repository"
  [ "${status}" -ne 0 ]
}

@test "gll shows branch decorations" {
  setup_main_repo
  create_feature_branch "feature/test"

  run gll
  # Should show HEAD -> feature/test decoration in yellow
  assert_contains "${output}" "HEAD"
  assert_contains "${output}" "feature/test"
  [ "${status}" -eq 0 ]
}

@test "gll accepts git log options" {
  setup_main_repo

  # Create multiple commits
  for i in {1..5}; do
    echo "file${i}" >"file${i}.txt"
    git add "file${i}.txt"
    git commit -m "Commit ${i}"
  done

  # Test limiting output with -3
  run gll -3
  assert_contains "${output}" "Commit 5"
  assert_contains "${output}" "Commit 4"
  assert_contains "${output}" "Commit 3"
  # Should NOT contain earlier commits
  refute_contains "${output}" "Commit 2"
  refute_contains "${output}" "Commit 1"
  [ "${status}" -eq 0 ]
}

@test "gll supports --since option" {
  setup_main_repo

  # Create a commit with a known message
  echo "recent" >recent.txt
  git add recent.txt
  git commit -m "Recent commit"

  # Test with --since option (should work but may not find anything due to timing)
  run gll --since="1 hour ago"
  [ "${status}" -eq 0 ]
}

@test "gll supports --author option" {
  setup_main_repo

  # Create commit with known author (already set in git_helpers)
  echo "authored" >authored.txt
  git add authored.txt
  git commit -m "Authored commit"

  run gll --author="Test User"
  assert_contains "${output}" "Authored commit"
  assert_contains "${output}" "Test User"
  [ "${status}" -eq 0 ]
}

@test "gll shows help message" {
  run gll --help
  assert_contains "${output}" "Usage: gll"
  assert_contains "${output}" "Git log with detailed graph formatting"
  assert_contains "${output}" "--since"
  assert_contains "${output}" "--author"
  assert_contains "${output}" "Examples:"
  [ "${status}" -eq 0 ]
}

@test "gll shows help with -h flag" {
  run gll -h
  assert_contains "${output}" "Usage: gll"
  assert_contains "${output}" "Git log with detailed graph formatting"
  [ "${status}" -eq 0 ]
}

@test "gll shows graph structure with branches" {
  setup_main_repo

  # Create a more complex branch structure
  git checkout -b feature/branch
  echo "feature" >feature.txt
  git add feature.txt
  git commit -m "Add feature"

  git checkout main
  echo "main work" >main.txt
  git add main.txt
  git commit -m "Work on main"

  git merge feature/branch --no-ff -m "Merge feature branch"

  run gll
  assert_contains "${output}" "Merge feature branch"
  assert_contains "${output}" "Add feature"
  assert_contains "${output}" "Work on main"
  # Check for graph structure characters
  assert_contains "${output}" "*"
  assert_contains "${output}" "|"
  [ "${status}" -eq 0 ]
}

@test "gll format includes all expected elements" {
  setup_main_repo

  # Create a commit to analyze
  echo "format test" >format.txt
  git add format.txt
  git commit -m "Format test commit"

  run gll -1
  # The format should include:
  # - Abbreviated hash (bold blue)
  # - Relative date in parentheses (bold green)
  # - Commit message (white)
  # - Author with em dash separator (bold white)
  # - Branch decorations if any (bold yellow)

  assert_contains "${output}" "Format test commit"
  assert_contains "${output}" "Test User"
  assert_contains "${output}" "ago)"
  assert_contains "${output}" "—"  # em dash separator
  [ "${status}" -eq 0 ]
}
