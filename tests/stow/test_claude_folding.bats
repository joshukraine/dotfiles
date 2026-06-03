#!/usr/bin/env bats

# Regression tests for the GNU Stow "folding trap" on the claude package (issue #205).
#
# On a fresh machine ~/.claude does not exist, so `stow claude/` folds the whole
# directory into a single symlink into the repo — and Claude Code then writes its
# runtime state into the dotfiles working tree. setup.sh's setup_directories()
# pre-creates ~/.claude as a real directory to prevent this. These tests lock in
# the resulting invariant: a pre-existing real .claude gets per-item symlinks, and
# CLAUDE.md (which the .stow-local-ignore once over-matched) is among them.

load '../helpers/common.bash'
load '../helpers/shell_helpers.bash'

setup() {
  command -v stow >/dev/null 2>&1 || skip "stow not installed"
  TEST_TMPDIR=$(mktemp -d)
}

teardown() {
  # Removes the temp target (symlinks only); never follows them into the repo.
  rm -rf "${TEST_TMPDIR}"
}

@test "claude: pre-existing real ~/.claude yields per-item symlinks, not a fold" {
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

@test "claude: missing target folds ~/.claude into one symlink (the trap setup.sh prevents)" {
  # No mkdir — an empty target reproduces a fresh machine.
  run stow -d "${DOTFILES}" -t "${TEST_TMPDIR}" claude
  [ "${status}" -eq 0 ]

  # The whole directory collapses into a single symlink. This is exactly the
  # state setup_directories() avoids by creating ~/.claude first.
  [ -L "${TEST_TMPDIR}/.claude" ]
}
