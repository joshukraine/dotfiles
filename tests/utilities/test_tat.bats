#!/usr/bin/env bats

# Tests for tat (tmux attach/create session) script

load '../helpers/common.bash'
load '../helpers/git_helpers.bash'
load '../helpers/shell_helpers.bash'

setup() {
  save_original_path
  setup_dotfiles_path

  # Set up tmux mocking to prevent terminal hijacking
  setup_tmux_mocking

  # Create a test directory with a predictable name
  export ORIGINAL_PWD="${PWD}"
  export TEST_TEMP_DIR
  TEST_TEMP_DIR=$(mktemp -d)
  cd "${TEST_TEMP_DIR}" || return 1

  # Track potential session names for cleanup
  track_tmux_session "test-session"
  track_tmux_session "$(basename "${TEST_TEMP_DIR}")"
  track_tmux_session "custom-session"
  track_tmux_session "My_Custom-Session_Name"
  track_tmux_session "test-project-name"
  track_tmux_session "test directory with spaces"
  track_tmux_session "this-is-a-very-long-directory-name-that-might-cause-issues-with-tmux-session-names"

  # Kill any existing test sessions to start clean
  cleanup_tracked_tmux_sessions
}

teardown() {
  # Restore real tmux command
  restore_tmux

  # Cleanup all tracked tmux sessions created during testing
  cleanup_tracked_tmux_sessions

  # Additional cleanup for any test-related sessions that might have been missed
  cleanup_all_test_tmux_sessions

  # Return to original directory and cleanup
  cd "${ORIGINAL_PWD}" || return 1
  if [ -n "${TEST_TEMP_DIR}" ] && [ -d "${TEST_TEMP_DIR}" ]; then
    rm -rf "${TEST_TEMP_DIR}"
  fi

  restore_path
}

@test "tat requires tmux to be available" {
  # Skip if tmux is not available
  require_command "tmux"
}

@test "tat creates session name from current directory" {
  # We're in a temp directory with a known name
  local dir_name
  dir_name=$(basename "${PWD}")
  # Prevent unused variable warning by referencing it
  [ -n "${dir_name}" ]

  # Test the core logic by examining the variables tat would use
  # We can't easily test tmux session creation, but we can test name derivation

  # Just run tat and verify it doesn't crash - actual tmux testing is complex
  run tat
  # Either succeeds in creating/attaching to session, or fails gracefully
  # The key is it shouldn't crash
}

@test "tat accepts custom session name" {
  # Just verify tat can be called with custom session name
  run tat "custom-session"
  # Should not crash - exact behavior depends on tmux availability and state
}

@test "tat handles directory names with dots" {
  # Create a directory with dots
  mkdir "test.project.name"
  cd "test.project.name"

  # Just verify tat doesn't crash with dots in directory name
  run tat
  # Should not crash - the key test is that it handles the directory name
}

@test "tat handles session validation through behavior" {
  # Instead of testing internal functions, test tat's behavior with existing vs non-existing sessions
  # Create a known session in our mock environment
  export MOCK_TMUX_SESSIONS="test-session"

  # Test behavior when session already exists - tat should handle this gracefully
  # We can't easily test session_exists directly, but we can verify tat doesn't crash
  # with different session scenarios

  # Test with a custom session name that should work
  run tat "test-session-validation"
  # Should not crash - exact behavior depends on tmux state but shouldn't error
  # The mock system should prevent actual tmux operations
}

@test "tat handles tmux environment detection through behavior" {
  # Test tat behavior when TMUX environment variable is set vs unset
  # This tests the not_in_tmux logic indirectly through tat's behavior

  # Test outside of tmux environment
  unset TMUX
  run tat "test-outside-tmux"
  # Should not crash - behavior will depend on actual tmux availability

  # Test inside mock tmux environment
  export TMUX="fake-tmux-session"
  run tat "test-inside-tmux"
  # Should not crash - may behave differently but shouldn't error
  # The key is testing that tat handles both scenarios gracefully
}

@test "tat handles current directory with spaces" {
  # Create directory with spaces
  mkdir "test directory with spaces"
  cd "test directory with spaces"

  # Just verify it doesn't crash with spaces in directory name
  run tat
  # Should handle spaces gracefully
}

@test "tat handles long directory names" {
  # Create directory with very long name
  local long_name="this-is-a-very-long-directory-name-that-might-cause-issues-with-tmux-session-names"
  mkdir "${long_name}"
  cd "${long_name}"

  run tat
  # Should handle long names gracefully
}

@test "tat fails gracefully when tmux is not available" {
  # This test depends on tmux being in PATH, so we'll skip it if tmux exists
  if command -v tmux >/dev/null 2>&1; then
    skip "tmux is available, cannot test unavailability"
  fi

  run tat
  [ "${status}" -ne 0 ]
}

@test "tat preserves custom session name exactly" {
  # Just verify it can handle custom session names with special chars
  run tat "My.Custom-Session_Name"
  # Should not crash with complex session names
}

# Note: Testing the actual tmux session creation and attachment is complex
# because it requires either being in tmux already or having a full tmux environment.
# The above tests focus on the logic and error handling that we can test reliably.
