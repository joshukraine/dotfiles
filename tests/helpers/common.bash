#!/usr/bin/env bash

# Common test helpers for dotfiles testing framework

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print colored output
print_red() {
  echo -e "${RED}$1${NC}"
}

print_green() {
  echo -e "${GREEN}$1${NC}"
}

print_yellow() {
  echo -e "${YELLOW}$1${NC}"
}

# Assert functions for better test readability
assert_equals() {
  local expected="$1"
  local actual="$2"
  local message="${3:-Values should be equal}"

  if [ "$expected" = "$actual" ]; then
    return 0
  else
    echo "Assertion failed: $message"
    echo "Expected: '$expected'"
    echo "Actual:   '$actual'"
    return 1
  fi
}

assert_not_equals() {
  local expected="$1"
  local actual="$2"
  local message="${3:-Values should not be equal}"

  if [ "$expected" != "$actual" ]; then
    return 0
  else
    echo "Assertion failed: $message"
    echo "Expected: not '$expected'"
    echo "Actual:   '$actual'"
    return 1
  fi
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local message="${3:-String should contain substring}"

  if [[ "$haystack" == *"$needle"* ]]; then
    return 0
  else
    echo "Assertion failed: $message"
    echo "String: '$haystack'"
    echo "Should contain: '$needle'"
    return 1
  fi
}

assert_file_exists() {
  local file="$1"
  local message="${2:-File should exist}"

  if [ -f "$file" ]; then
    return 0
  else
    echo "Assertion failed: $message"
    echo "File does not exist: '$file'"
    return 1
  fi
}

assert_directory_exists() {
  local dir="$1"
  local message="${2:-Directory should exist}"

  if [ -d "$dir" ]; then
    return 0
  else
    echo "Assertion failed: $message"
    echo "Directory does not exist: '$dir'"
    return 1
  fi
}

assert_command_succeeds() {
  local command="$1"
  local message="${2:-Command should succeed}"

  if eval "$command" >/dev/null 2>&1; then
    return 0
  else
    echo "Assertion failed: $message"
    echo "Command failed: '$command'"
    return 1
  fi
}

assert_command_fails() {
  local command="$1"
  local message="${2:-Command should fail}"

  if ! eval "$command" >/dev/null 2>&1; then
    return 0
  else
    echo "Assertion failed: $message"
    echo "Command succeeded when it should have failed: '$command'"
    return 1
  fi
}

# Test timeout function
run_with_timeout() {
  local timeout="$1"
  shift

  timeout "$timeout" bash -c "$*"
}

# Skip test with reason
skip_test() {
  local reason="$1"
  print_yellow "SKIP: $reason"
  exit 0
}

# Test prerequisites
require_command() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    skip_test "Required command '$cmd' not found"
  fi
}

require_file() {
  local file="$1"
  if [ ! -f "$file" ]; then
    skip_test "Required file '$file' not found"
  fi
}

# Temporary file helpers
create_temp_file() {
  mktemp
}

create_temp_dir() {
  mktemp -d
}

# Mock command helper
mock_command() {
  local cmd="$1"
  local mock_output="$2"
  local mock_exit_code="${3:-0}"

  # Create a temporary mock script
  local mock_script
  mock_script=$(mktemp)

  cat > "$mock_script" << EOF
#!/bin/bash
echo "$mock_output"
exit $mock_exit_code
EOF

  chmod +x "$mock_script"

  # Add mock to PATH
  local mock_dir
  mock_dir=$(dirname "$mock_script")
  export PATH="$mock_dir:$PATH"

  # Rename mock script to command name
  mv "$mock_script" "$mock_dir/$cmd"

  # Return cleanup function
  echo "$mock_dir/$cmd"
}

# Cleanup mock command
cleanup_mock() {
  local mock_path="$1"
  rm -f "$mock_path"
}

# Performance measurement
measure_time() {
  local start_time
  local end_time
  local duration
  start_time=$(date +%s.%N)
  "$@"
  end_time=$(date +%s.%N)
  duration=$(echo "$end_time - $start_time" | bc)
  echo "Execution time: ${duration}s"
}
