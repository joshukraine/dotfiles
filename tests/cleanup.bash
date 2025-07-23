#!/usr/bin/env bash

# Test cleanup script - run after test suite to clean up any remaining resources

# Source helpers
source "$(dirname "$0")/helpers/shell_helpers.bash"

echo "Cleaning up test resources..."

# Cleanup any remaining test tmux sessions
echo "Cleaning up tmux sessions..."
cleanup_all_test_tmux_sessions

# Count remaining sessions to verify cleanup
remaining_sessions=$(tmux list-sessions 2> /dev/null | grep -cE "(tmp-|test-|custom-session|My_Custom-Session_Name)" || echo 0)
echo "Remaining test sessions: ${remaining_sessions}"

# Clean up any temporary files that might have been left behind
echo "Cleaning up temporary files..."
find /tmp -name "tmp.*" -type d -mtime +1 -exec rm -rf {} + 2> /dev/null || true

echo "Cleanup complete."
