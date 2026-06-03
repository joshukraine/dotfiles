#!/usr/bin/env bats

# Regression tests for the GNU Stow "folding trap" on the claude package (issue #205).
#
# On a fresh machine ~/.claude does not exist, so `stow claude/` would fold the
# whole directory into a single symlink into the repo — and Claude Code then
# writes its runtime state into the dotfiles working tree. setup.sh's
# setup_directories() pre-creates ~/.claude (via ensure_dir) as a real directory
# to prevent this. Test 1 drives that production code path directly; test 2 locks
# in the resulting stow invariant (per-item symlinks, CLAUDE.md included).

load '../helpers/common.bash'
load '../helpers/shell_helpers.bash'

setup() {
  TEST_TMPDIR=$(mktemp -d)
}

teardown() {
  # Removes the temp target only (symlinks, never followed into the repo).
  rm -rf "${TEST_TMPDIR}"
}

@test "setup_directories creates ~/.claude as a real directory (guards the fix)" {
  # Run the real production function against a throwaway HOME. If the ~/.claude
  # creation is removed or broken in setup.sh, this fails. setup.sh guards its
  # main() behind a BASH_SOURCE check, so sourcing it here is side-effect free.
  #
  # The bash -c body is single-quoted on purpose: ${HOME} and ${DOTFILES} must be
  # expanded by the inner shell (from the env we pass it), not by bats.
  # shellcheck disable=SC2016
  run env HOME="${TEST_TMPDIR}/home" DOTFILES="${DOTFILES}" bash -c '
    mkdir -p "${HOME}"
    source "${DOTFILES}/setup.sh"
    setup_directories >/dev/null 2>&1
    [ -d "${HOME}/.claude" ] && [ ! -L "${HOME}/.claude" ]
  '
  [ "${status}" -eq 0 ]
}

@test "stowing into a pre-existing real ~/.claude links each item, not a fold" {
  command -v stow >/dev/null 2>&1 || skip "stow not installed"
  mkdir "${TEST_TMPDIR}/.claude"

  run stow -d "${DOTFILES}" -t "${TEST_TMPDIR}" claude
  [ "${status}" -eq 0 ]

  # .claude stays a real directory rather than collapsing into one symlink.
  [ -d "${TEST_TMPDIR}/.claude" ]
  [ ! -L "${TEST_TMPDIR}/.claude" ]

  # Each managed item is its own symlink inside the real directory.
  for item in CLAUDE.md settings.json starship.toml skills docs presets; do
    [ -L "${TEST_TMPDIR}/.claude/${item}" ]
  done

  # CLAUDE.md must resolve to the real file (regression guard for the
  # .stow-local-ignore fix in d2549ae, where a blanket *.md once dropped it).
  [ -e "${TEST_TMPDIR}/.claude/CLAUDE.md" ]

  # Reference docs stay excluded by .stow-local-ignore.
  [ ! -e "${TEST_TMPDIR}/.claude/cheatsheet.md" ]
}
