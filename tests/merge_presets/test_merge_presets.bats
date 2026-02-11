#!/usr/bin/env bats

# Tests for merge-presets script

load '../helpers/common.bash'
load '../helpers/shell_helpers.bash'

setup() {
  save_original_path
  setup_dotfiles_path

  # Create temp directory for test fixtures
  TEST_TMPDIR=$(mktemp -d)

  # Base preset
  cat > "${TEST_TMPDIR}/base.json" <<'JSON'
{
  "permissions": {
    "allow": [
      "Edit",
      "Bash(git add:*)",
      "Bash(git commit:*)"
    ],
    "deny": [
      "Bash(rm -rf:*)"
    ]
  }
}
JSON

  # Overlay preset
  cat > "${TEST_TMPDIR}/overlay.json" <<'JSON'
{
  "permissions": {
    "allow": [
      "Bash(bundle:*)",
      "Bash(rails:*)"
    ],
    "deny": [
      "Bash(rails db:drop:*)"
    ]
  }
}
JSON

  # Second overlay with some duplicates
  cat > "${TEST_TMPDIR}/overlay2.json" <<'JSON'
{
  "permissions": {
    "allow": [
      "Bash(git add:*)",
      "Bash(hugo:*)"
    ],
    "deny": [
      "Bash(rm -rf:*)"
    ]
  }
}
JSON

  # Invalid JSON file (missing permissions key)
  cat > "${TEST_TMPDIR}/invalid.json" <<'JSON'
{
  "allow": ["Edit"]
}
JSON
}

teardown() {
  restore_path
  rm -rf "${TEST_TMPDIR}"
}

@test "merge-presets requires at least 2 arguments" {
  run merge-presets
  [ "${status}" -ne 0 ]
  assert_contains "${output}" "Usage:"
}

@test "merge-presets fails with only 1 argument" {
  run merge-presets "${TEST_TMPDIR}/base.json"
  [ "${status}" -ne 0 ]
  assert_contains "${output}" "Usage:"
}

@test "merge-presets fails with nonexistent file" {
  run merge-presets "${TEST_TMPDIR}/base.json" "${TEST_TMPDIR}/nonexistent.json"
  [ "${status}" -ne 0 ]
  assert_contains "${output}" "Cannot find"
}

@test "merge-presets fails with invalid JSON structure" {
  run merge-presets "${TEST_TMPDIR}/base.json" "${TEST_TMPDIR}/invalid.json"
  [ "${status}" -ne 0 ]
  assert_contains "${output}" "not a valid permissions file"
}

@test "merge-presets produces valid JSON output" {
  run merge-presets "${TEST_TMPDIR}/base.json" "${TEST_TMPDIR}/overlay.json"
  [ "${status}" -eq 0 ]

  # Output should be valid JSON with a permissions key
  echo "${output}" | jq -e '.permissions' > /dev/null
}

@test "merge-presets merges allow arrays" {
  run merge-presets "${TEST_TMPDIR}/base.json" "${TEST_TMPDIR}/overlay.json"
  [ "${status}" -eq 0 ]

  local allow_count
  allow_count=$(echo "${output}" | jq '.permissions.allow | length')
  # base has 3 + overlay has 2 = 5 unique entries
  [ "${allow_count}" -eq 5 ]
}

@test "merge-presets merges deny arrays" {
  run merge-presets "${TEST_TMPDIR}/base.json" "${TEST_TMPDIR}/overlay.json"
  [ "${status}" -eq 0 ]

  local deny_count
  deny_count=$(echo "${output}" | jq '.permissions.deny | length')
  # base has 1 + overlay has 1 = 2 unique entries
  [ "${deny_count}" -eq 2 ]
}

@test "merge-presets deduplicates entries" {
  run merge-presets "${TEST_TMPDIR}/base.json" "${TEST_TMPDIR}/overlay2.json"
  [ "${status}" -eq 0 ]

  # overlay2 has Bash(git add:*) which duplicates base — should not appear twice
  local git_add_count
  git_add_count=$(echo "${output}" | jq '[.permissions.allow[] | select(. == "Bash(git add:*)")] | length')
  [ "${git_add_count}" -eq 1 ]

  # rm -rf in both deny lists — should appear once
  local rm_rf_count
  rm_rf_count=$(echo "${output}" | jq '[.permissions.deny[] | select(. == "Bash(rm -rf:*)")] | length')
  [ "${rm_rf_count}" -eq 1 ]
}

@test "merge-presets sorts output" {
  run merge-presets "${TEST_TMPDIR}/base.json" "${TEST_TMPDIR}/overlay.json"
  [ "${status}" -eq 0 ]

  # First allow entry should come first alphabetically
  local first_allow
  first_allow=$(echo "${output}" | jq -r '.permissions.allow[0]')
  [ "${first_allow}" = "Bash(bundle:*)" ]
}

@test "merge-presets handles three or more files" {
  run merge-presets "${TEST_TMPDIR}/base.json" "${TEST_TMPDIR}/overlay.json" "${TEST_TMPDIR}/overlay2.json"
  [ "${status}" -eq 0 ]

  # Should have all unique entries from all three files
  # base: Edit, git add, git commit (3)
  # overlay: bundle, rails (2)
  # overlay2: git add (dup), hugo (1 new)
  # Total unique: 6
  local allow_count
  allow_count=$(echo "${output}" | jq '.permissions.allow | length')
  [ "${allow_count}" -eq 6 ]
}
