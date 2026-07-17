#!/usr/bin/env bats

# Tests for bubo, the staleness report (see https://github.com/joshukraine/dotfiles/issues/236).
#
# These test the probes' classification logic, not the surfaces themselves. CI
# has no zap, no tpm and no mason, and even locally a test that asserted "tpm is
# one commit behind" would break the moment tpm was updated. So the clone probe
# runs against purpose-built local fixture repos, which also keeps the suite
# offline: a file:// origin needs no network.
#
# The load-bearing test here is the cat-file one. The whole report is worthless
# if it under-reports staleness, and the obvious clone check does exactly that.
#
# bubo is sourced in a subshell rather than by bats directly, because it sets
# -euo pipefail for its own use and that should not leak into the test runner.

load '../helpers/common.bash'
load '../helpers/shell_helpers.bash'

setup() {
  require_command git

  BUBO="${DOTFILES}/bin/.local/bin/bubo"
  require_file "${BUBO}"

  TEST_TMPDIR="$(mktemp -d)"
}

teardown() {
  if [ -n "${TEST_TMPDIR}" ] && [ -d "${TEST_TMPDIR}" ]; then
    rm -rf "${TEST_TMPDIR}"
  fi
}

# Run one of bubo's functions in a subshell and capture its output.
run_bubo() {
  run bash -c "source '${BUBO}' && $*"
}

# Create an origin repo and a clone of it. Sets ORIGIN and CLONE.
#
# init.defaultBranch is set rather than passing -b so this works on git versions
# predating the flag; nothing here depends on the branch's name, only on HEAD.
make_clone() {
  ORIGIN="${TEST_TMPDIR}/origin"
  CLONE="${TEST_TMPDIR}/clone"

  git -c init.defaultBranch=main init -q "${ORIGIN}"
  git -C "${ORIGIN}" config user.name "Test User"
  git -C "${ORIGIN}" config user.email "test@example.com"
  echo "one" >"${ORIGIN}/file"
  git -C "${ORIGIN}" add file
  git -C "${ORIGIN}" commit -qm "one"

  git clone -q "${ORIGIN}" "${CLONE}"
  git -C "${CLONE}" config user.name "Test User"
  git -C "${CLONE}" config user.email "test@example.com"
}

# Commit to the origin, leaving the clone a commit behind.
advance_origin() {
  echo "two" >>"${ORIGIN}/file"
  git -C "${ORIGIN}" add file
  git -C "${ORIGIN}" commit -qm "two"
}

# Commit to the clone, putting it a commit ahead of the origin.
advance_clone() {
  echo "local" >>"${CLONE}/file"
  git -C "${CLONE}" add file
  git -C "${CLONE}" commit -qm "local work"
}

# Put a fake asdf on PATH whose `latest` reports a fixed version.
mock_asdf_latest() {
  local latest="$1"

  mkdir -p "${TEST_TMPDIR}/bin"
  cat >"${TEST_TMPDIR}/bin/asdf" <<EOF
#!/usr/bin/env bash
[ "\$1" = "latest" ] || exit 1
echo "${latest}"
EOF
  chmod +x "${TEST_TMPDIR}/bin/asdf"
  PATH="${TEST_TMPDIR}/bin:${PATH}"
}

# --- the test seam -----------------------------------------------------------

@test "sourcing bubo does not run the report" {
  run_bubo "echo SOURCED"

  assert_equals "0" "${status}" "sourcing bubo should succeed"
  assert_contains "${output}" "SOURCED"
  assert_not_contains "${output}" "homebrew" "sourcing should not produce a report"
}

# --- clone staleness ---------------------------------------------------------

@test "probe_clone reports a clone at origin's HEAD as current" {
  make_clone

  run_bubo "probe_clone '${CLONE}'"

  assert_contains "${output}" "CURRENT"
}

@test "probe_clone reports a behind clone as stale, with both short SHAs" {
  make_clone
  advance_origin

  local local_sha remote_sha
  local_sha="$(git -C "${CLONE}" rev-parse --short=7 HEAD)"
  remote_sha="$(git -C "${ORIGIN}" rev-parse --short=7 HEAD)"

  run_bubo "probe_clone '${CLONE}'"

  assert_contains "${output}" "STALE"
  assert_contains "${output}" "${local_sha} -> ${remote_sha}"
}

# The one that matters. Checking "is the remote HEAD present locally?" with
# `git cat-file -e` reports stale clones as current, because an earlier fetch
# already pulled the object into the local store even though HEAD never moved.
# Measured against the real tpm and vim-tmux-navigator clones, which it called
# current while each sat a commit behind.
#
# The first assertion proves the fixture actually reproduces the trap, so this
# cannot quietly stop testing anything if the setup changes.
@test "probe_clone reports a fetched-but-unmerged clone as stale, not current" {
  make_clone
  advance_origin
  git -C "${CLONE}" fetch -q origin

  local remote_sha
  remote_sha="$(git -C "${ORIGIN}" rev-parse HEAD)"

  run git -C "${CLONE}" cat-file -e "${remote_sha}"
  assert_equals "0" "${status}" "fixture is broken: the remote object should be in the local store"

  run_bubo "probe_clone '${CLONE}'"

  assert_contains "${output}" "STALE"
  assert_not_contains "${output}" "CURRENT"
}

@test "probe_clone reports a clone with local commits as ahead, not stale" {
  make_clone
  advance_clone

  run_bubo "probe_clone '${CLONE}'"

  assert_contains "${output}" "AHEAD"
  assert_not_contains "${output}" "STALE"
}

@test "probe_clone reports UNKNOWN, never current, when origin cannot be reached" {
  make_clone
  git -C "${CLONE}" remote set-url origin "${TEST_TMPDIR}/no-such-origin"

  run_bubo "probe_clone '${CLONE}'"

  assert_contains "${output}" "UNKNOWN"
  assert_not_contains "${output}" "CURRENT"
}

@test "probe_clone reports UNKNOWN for a directory that is not a git clone" {
  mkdir -p "${TEST_TMPDIR}/plain"

  run_bubo "probe_clone '${TEST_TMPDIR}/plain'"

  assert_contains "${output}" "UNKNOWN"
  assert_not_contains "${output}" "CURRENT"
}

@test "clone_dirs_in finds clones and ignores plain directories" {
  make_clone
  mkdir -p "${TEST_TMPDIR}/plain"

  run_bubo "clone_dirs_in '${TEST_TMPDIR}'"

  assert_contains "${output}" "${CLONE}"
  assert_not_contains "${output}" "${TEST_TMPDIR}/plain"
}

# --- asdf tool versions ------------------------------------------------------

@test "probe_asdf_tool reports a pin matching latest as current" {
  mock_asdf_latest "4.0.6"

  run_bubo "PATH='${PATH}'; probe_asdf_tool ruby '4.0.6'"

  assert_contains "${output}" "CURRENT"
}

@test "probe_asdf_tool reports a pin behind latest as stale" {
  mock_asdf_latest "26.5.0"

  run_bubo "PATH='${PATH}'; probe_asdf_tool nodejs '24.16.0'"

  assert_contains "${output}" "STALE"
  assert_contains "${output}" "24.16.0 -> 26.5.0"
}

@test "probe_asdf_tool reports a multi-version pin as current when one matches latest" {
  mock_asdf_latest "3.12.4"

  run_bubo "PATH='${PATH}'; probe_asdf_tool python '3.12.4 2.7.18'"

  assert_contains "${output}" "CURRENT"
}

# A symbolic pin resolves at runtime, so comparing it against a version number is
# not a comparison at all -- it would report a permanent false "stale".
@test "probe_asdf_tool reports a symbolic pin as UNKNOWN, not stale" {
  mock_asdf_latest "0.12.4"

  run_bubo "PATH='${PATH}'; probe_asdf_tool neovim 'stable'"

  assert_contains "${output}" "UNKNOWN"
  assert_not_contains "${output}" "STALE"
}

@test "probe_asdf_tool reports UNKNOWN, never current, when asdf gives no answer" {
  mkdir -p "${TEST_TMPDIR}/bin"
  printf '#!/usr/bin/env bash\nexit 1\n' >"${TEST_TMPDIR}/bin/asdf"
  chmod +x "${TEST_TMPDIR}/bin/asdf"

  run_bubo "PATH='${TEST_TMPDIR}/bin:${PATH}'; probe_asdf_tool ruby '4.0.6'"

  assert_contains "${output}" "UNKNOWN"
  assert_not_contains "${output}" "CURRENT"
}

# --- rendering ---------------------------------------------------------------

@test "render_records lists what is stale, counts what is current, and prints the fix" {
  run_bubo "printf 'alpha\tCURRENT\t\nbravo\tSTALE\tabc1234 -> def5678\n' | render_records 'demo' 'run the fix'"

  assert_contains "${output}" "1 stale, 1 current"
  assert_contains "${output}" "bravo"
  assert_contains "${output}" "abc1234 -> def5678"
  assert_contains "${output}" "fix: run the fix"
  assert_not_contains "${output}" "alpha" "current items should be counted, not listed"
}

@test "render_records prints no fix when nothing is stale" {
  run_bubo "printf 'alpha\tCURRENT\t\n' | render_records 'demo' 'run the fix'"

  assert_contains "${output}" "1 current"
  assert_not_contains "${output}" "fix:"
}

@test "render_records surfaces UNKNOWN items rather than folding them into current" {
  run_bubo "printf 'alpha\tUNKNOWN\tno answer from origin\n' | render_records 'demo' 'run the fix'"

  assert_contains "${output}" "1 unknown"
  assert_contains "${output}" "UNKNOWN: no answer from origin"
  assert_not_contains "${output}" "current"
}

@test "render_records prints a note under the verdict when given one" {
  run_bubo "printf 'alpha\tCURRENT\t\n' | render_records 'mason' 'run the fix' 'registry data: 4h old'"

  assert_contains "${output}" "registry data: 4h old"
}
