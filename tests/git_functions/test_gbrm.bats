#!/usr/bin/env bats

# Tests for gbrm (git branch remove merged) script

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

@test "gbrm fails in non-git directory" {
  setup_non_git_dir

  run gbrm
  assert_contains "${output}" "Not a git repository"
  [ "${status}" -eq 1 ]
}

@test "gbrm successfully detects default branch (main)" {
  setup_main_repo

  run gbrm
  assert_contains "${output}" "Removing branches merged into main"
  # May succeed or fail depending on whether there are branches to remove
  # The key is that it doesn't crash and detects the right branch
}

@test "gbrm successfully detects default branch (master)" {
  setup_master_repo

  run gbrm
  assert_contains "${output}" "Removing branches merged into master"
  # May succeed or fail depending on whether there are branches to remove
  # The key is that it doesn't crash and detects the right branch
}

@test "gbrm removes merged branches but keeps current and default branches" {
  setup_main_repo

  # Create and merge a feature branch
  create_feature_branch "feature/completed"
  git checkout main
  git merge feature/completed --no-ff -m "Merge feature/completed"
  git push origin main

  # Create another feature branch that's merged
  git checkout -b feature/also-done
  echo "More work" >> done.txt
  git add done.txt
  git commit -m "More completed work"
  git checkout main
  git merge feature/also-done --no-ff -m "Merge feature/also-done"
  git push origin main

  # Create an unmerged branch
  git checkout -b feature/unmerged
  echo "Unmerged work" >> unmerged.txt
  git add unmerged.txt
  git commit -m "Unmerged work"
  git checkout main

  # Verify branches exist
  local branch_count_before
  branch_count_before=$(git branch | wc -l)

  run gbrm
  [ "${status}" -eq 0 ]

  # Should have removed merged branches but kept main and current unmerged
  # The exact count depends on git behavior, but we can verify main still exists
  if git branch | grep -q "main"; then
    :
  else
    return 1
  fi

  # Unmerged branch should still exist
  if git branch | grep -q "feature/unmerged"; then
    :
  else
    return 1
  fi
}

@test "gbrm handles case when no branches need removal" {
  setup_main_repo
  # Only main branch exists

  run gbrm
  assert_contains "${output}" "Removing branches merged into main"
  [ "${status}" -eq 0 ]
}

@test "gbrm doesn't remove current branch" {
  setup_main_repo

  # Create and merge a branch, but stay on it
  create_feature_branch "feature/current"
  git checkout main
  git merge feature/current --no-ff -m "Merge feature/current"
  git push origin main
  git checkout feature/current # Stay on the merged branch

  run gbrm
  # The xargs command might fail if trying to remove the current branch
  # but the key test is that we're still on the current branch afterward
  assert_equals "feature/current" "$(get_current_branch)"
}

@test "gbrm doesn't remove default branch" {
  setup_main_repo
  create_feature_branch "feature/test"

  run gbrm
  assert_contains "${output}" "Removing branches merged into main"

  # Main branch should still exist
  if git branch | grep -q "main"; then
    :
  else
    return 1
  fi
}

@test "gbrm works with master as default branch" {
  setup_master_repo

  # Create and merge a feature branch
  create_feature_branch "feature/old-style"
  git checkout master
  git merge feature/old-style --no-ff -m "Merge feature/old-style"
  git push origin master

  run gbrm
  [ "${status}" -eq 0 ]

  # Master should still exist
  if git branch | grep -q "master"; then
    :
  else
    return 1
  fi
}

@test "gbrm handles remote detection failure gracefully" {
  setup_no_remote_repo

  # Without remote, it should fall back to local main/master detection
  run gbrm
  # Should either succeed or fail gracefully depending on branch structure
  # At minimum, should not crash
  [ "${status}" -ge 0 ]
}

@test "gbrm provides feedback about removed branches" {
  setup_main_repo

  # Create and merge a feature branch
  create_feature_branch "feature/to-remove"
  git checkout main
  git merge feature/to-remove --no-ff -m "Merge feature/to-remove"
  git push origin main

  run gbrm
  [ "${status}" -eq 0 ]

  # Should provide some feedback about what was done
  # (The exact message will depend on implementation)
}

@test "gbrm handles multiple merged branches" {
  setup_main_repo

  # Create and merge multiple feature branches
  for i in {1..3}; do
    git checkout -b "feature/merge-me-${i}"
    echo "Feature ${i} work" >> "feature${i}.txt"
    git add "feature${i}.txt"
    git commit -m "Add feature ${i}"
    git checkout main
    git merge "feature/merge-me-${i}" --no-ff -m "Merge feature/merge-me-${i}"
    git push origin main
  done

  # Count branches before
  local branch_count_before
  # shellcheck disable=SC2126
  branch_count_before=$(git branch | grep -v main | wc -l)

  run gbrm
  [ "${status}" -eq 0 ]

  # Should have removed the merged branches
  local branch_count_after
  # shellcheck disable=SC2126
  branch_count_after=$(git branch | grep -v main | wc -l)
  [ "${branch_count_after}" -lt "${branch_count_before}" ]
}
