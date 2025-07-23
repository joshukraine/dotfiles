#!/usr/bin/env bash

# Git test helpers for dotfiles testing framework

# Create a temporary directory for git repository testing
setup_test_git_repo() {
  export TEST_TEMP_DIR
  TEST_TEMP_DIR=$(mktemp -d)
  cd "${TEST_TEMP_DIR}" || exit
}

# Clean up temporary git repository
teardown_test_git_repo() {
  if [ -n "${TEST_TEMP_DIR}" ] && [ -d "${TEST_TEMP_DIR}" ]; then
    rm -rf "${TEST_TEMP_DIR}"
    unset TEST_TEMP_DIR
  fi
}

# Initialize a basic git repository with initial commit
init_git_repo() {
  local default_branch="${1:-main}"

  # Initialize repository - handle different git versions
  if git init -b "${default_branch}" 2> /dev/null; then
    # Modern git supports -b flag
    :
  else
    # Fallback for older git versions
    git init
    git checkout -b "${default_branch}"
  fi

  git config user.name "Test User"
  git config user.email "test@example.com"
  echo "# Test Repository" > README.md
  git add README.md
  git commit -m "Initial commit"
}

# Add a mock origin remote
add_mock_origin() {
  local default_branch="${1:-main}"
  # Create a bare repo to simulate remote
  local remote_dir="${TEST_TEMP_DIR}/remote"
  git init --bare "${remote_dir}"
  git remote add origin "${remote_dir}"
  git push -u origin "${default_branch}"

  # Set up remote HEAD to point to default branch
  cd "${remote_dir}" || exit
  git symbolic-ref HEAD "refs/heads/${default_branch}"
  cd "${TEST_TEMP_DIR}" || exit
}

# Create a feature branch
create_feature_branch() {
  local branch_name="${1:-feature/test-branch}"
  git checkout -b "${branch_name}"
  echo "Feature work" >> feature.txt
  git add feature.txt
  git commit -m "Add feature work"
}

# Create uncommitted changes
create_uncommitted_changes() {
  echo "Uncommitted changes" >> uncommitted.txt
  git add uncommitted.txt
}

# Create unstaged changes
create_unstaged_changes() {
  echo "Unstaged changes" >> README.md
}

# Simulate a repository with master as default branch (legacy)
setup_master_repo() {
  setup_test_git_repo
  init_git_repo "master"
  add_mock_origin "master"
}

# Simulate a repository with main as default branch (modern)
setup_main_repo() {
  setup_test_git_repo
  init_git_repo "main"
  add_mock_origin "main"
}

# Simulate a repository without origin remote
setup_no_remote_repo() {
  setup_test_git_repo
  init_git_repo
}

# Simulate non-git directory
setup_non_git_dir() {
  export TEST_TEMP_DIR
  TEST_TEMP_DIR=$(mktemp -d)
  cd "${TEST_TEMP_DIR}" || exit
  echo "Not a git repository" > file.txt
}

# Check if current directory is a git repository
is_git_repo() {
  git rev-parse --is-inside-work-tree > /dev/null 2>&1
}

# Get current branch name
get_current_branch() {
  git branch --show-current 2> /dev/null
}

# Check if remote exists
has_origin_remote() {
  git remote | grep -q "^origin$"
}

# Get default branch from remote
get_remote_default_branch() {
  git remote show origin 2> /dev/null | awk '/HEAD branch/ { print $NF }'
}
