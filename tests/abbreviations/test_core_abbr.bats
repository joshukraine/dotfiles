#!/usr/bin/env bats

# Tests for core shell abbreviations

load '../helpers/common.bash'
load '../helpers/shell_helpers.bash'

setup() {
  # Ensure abbreviation file exists
  require_file "${DOTFILES}/zsh/.config/zsh-abbr/abbreviations.zsh"
}

@test "core unix abbreviations are defined correctly" {
  # Test a few key abbreviations from different categories
  test_abbreviation "c" "clear"
  test_abbreviation "ga" "git add"
  test_abbreviation "gst" "git status"
}

@test "homebrew abbreviations work in both shells" {
  test_abbreviation "brc" "brew cleanup"
  test_abbreviation "bru" "brew update"
  test_abbreviation "brg" "brew upgrade"
}

@test "claude code abbreviations are properly defined" {
  test_abbreviation "cl" "claude"
  test_abbreviation "clh" "claude --help"
  test_abbreviation "clv" "claude --version"
}

@test "git abbreviations have consistent expansions" {
  test_abbreviation "gaa" "git add --all"
  test_abbreviation "gcm" "git cm"
  test_abbreviation "gco" "git checkout"
  test_abbreviation "gsw" "git switch"
  test_abbreviation "gswc" "git switch -c"
  test_abbreviation "gbr" "git branch --remote"
}

@test "development utility abbreviations work" {
  test_abbreviation "cv" "command -v"
  test_abbreviation "mkdir" "mkdir -pv"
  test_abbreviation "mv" "mv -iv"
}

@test "cp expands to GNU cp" {
  test_abbreviation "cp" "gcp -iv"
}

@test "gcp is not abbreviated, so it reaches the GNU cp binary" {
  # gcp is GNU cp (brew coreutils) and is what cp expands to. An abbr on gcp
  # would shadow the binary, making it unreachable by name.
  run grep -F 'abbr "gcp"=' "${DOTFILES}/zsh/.config/zsh-abbr/abbreviations.zsh"
  [ "${status}" -ne 0 ]
}

@test "every abbr line in the file actually registers with zsh-abbr" {
  # The tests above read the file as text, so they pass even when a line fails
  # to parse. zsh sources this file with INTERACTIVE_COMMENTS off, so a trailing
  # `# comment` on an abbr line is read as arguments and the line is dropped
  # silently. Compare the file against what zsh-abbr actually loaded.
  local abbr_file="${DOTFILES}/zsh/.config/zsh-abbr/abbreviations.zsh"
  local in_file loaded

  in_file=$(grep -c '^abbr ' "${abbr_file}")
  loaded=$(zsh -i -c 'abbr list 2>/dev/null | wc -l' 2>/dev/null | tr -d ' ')

  [ "${in_file}" -eq "${loaded}" ]
}

@test "tmux abbreviations are available" {
  test_abbreviation "tl" "tmux ls"
  test_abbreviation "tlw" "tmux list-windows"
}

@test "system tool abbreviations work" {
  test_abbreviation "df" "df -h"
  test_abbreviation "du" "du -h"
  test_abbreviation "dud" "du -d 1 -h"
}

@test "abbreviation file exists and is not empty" {
  local zsh_abbr_file="${DOTFILES}/zsh/.config/zsh-abbr/abbreviations.zsh"

  assert_file_exists "${zsh_abbr_file}"

  # Check file is not empty
  [ -s "${zsh_abbr_file}" ]
}
