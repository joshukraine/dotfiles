#!/usr/bin/env bats

# Tests for the agent-safety rule (see zsh/README.md "Agents and the alias layer").
#
# Aliases are the only layer of this config that reaches a coding agent, so
# .zshrc drops them in non-interactive shells. These tests cover the two halves
# of that: the guard is present and correctly placed, and zsh actually behaves
# the way the guard assumes.
#
# The behavioural tests use a synthetic rc file rather than the real ~/.zshrc.
# CI installs zsh but never stows the dotfiles or installs zap/eza, so sourcing
# the real file there proves nothing. A synthetic rc tests the mechanism itself
# on the same zsh the user runs.

load '../helpers/common.bash'
load '../helpers/shell_helpers.bash'

setup() {
  require_command zsh
  require_file "${DOTFILES}/zsh/.zshrc"
}

@test "zshrc drops aliases in non-interactive shells" {
  run grep -c '^\[\[ -o interactive \]\] || unalias -a$' "${DOTFILES}/zsh/.zshrc"
  assert_equals "1" "${output}" "the alias guard should appear exactly once"
}

@test "the alias guard is the last executable line in zshrc" {
  # Placement is load-bearing: aliases arrive from plugins.zsh (the exa plugin
  # defines ls/ll/la/tree), aliases.zsh, and .zshrc.local. A guard that runs
  # before any of them leaves those aliases exposed to agents.
  local last
  last=$(grep -vE '^\s*(#|$)' "${DOTFILES}/zsh/.zshrc" | tail -1)
  assert_equals '[[ -o interactive ]] || unalias -a' "${last}"
}

@test "a non-interactive zsh drops guarded aliases" {
  local rc
  rc=$(create_temp_file)
  cat >"${rc}" <<'EOF'
alias ls='eza --icons'
alias vim='nvim'
[[ -o interactive ]] || unalias -a
EOF

  run zsh -c "source '${rc}'; alias | wc -l | tr -d ' '"
  assert_equals "0" "${output}" "an agent shell should see no aliases"
  rm -f "${rc}"
}

@test "an interactive zsh keeps guarded aliases" {
  local rc
  rc=$(create_temp_file)
  cat >"${rc}" <<'EOF'
alias test_guard_canary='echo canary'
[[ -o interactive ]] || unalias -a
EOF

  run zsh -i -c "source '${rc}'; alias test_guard_canary"
  assert_contains "${output}" "canary" "a human shell should keep its aliases"
  rm -f "${rc}"
}

@test "the guard leaves functions intact for agents" {
  # Only the alias layer is swept. Functions are how gcom/gpum/grbm reach
  # agents, so unalias -a must not disturb them.
  local rc
  rc=$(create_temp_file)
  cat >"${rc}" <<'EOF'
alias ls='eza --icons'
function agent_visible_fn() { echo "still here"; }
[[ -o interactive ]] || unalias -a
EOF

  run zsh -c "source '${rc}'; agent_visible_fn"
  assert_equals "still here" "${output}"
  rm -f "${rc}"
}

@test "eza aliases pin every optional-value flag to an explicit value" {
  # eza's --icons, --hyperlink, --classify and --color all take an OPTIONAL
  # value, so a bare long form swallows the following path: `ls /tmp` becomes
  # `--icons=/tmp` and errors to stderr with an empty stdout, which reads as a
  # valid answer. Short forms (-F) attach their value and are unaffected.
  # Read alias definitions only: the prose above the `ls` alias names the bare
  # flags it warns about, and would match otherwise. Within those lines, match a
  # flag NOT followed by '=', which catches a trailing quote or end of line as
  # well as whitespace. Excluding '-' and alphanumerics keeps real flags like
  # --color-scale from tripping it.
  local bare
  bare=$(grep -E '^[[:space:]]*alias ' "${DOTFILES}/zsh/.config/zsh/aliases.zsh" |
    grep -E -- '--(icons|hyperlink|classify|color|colour)([^=[:alnum:]-]|$)' || true)

  assert_equals "" "${bare}" "optional-value flags must be written as --flag=value"
}
