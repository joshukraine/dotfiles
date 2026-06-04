#!/usr/bin/env bash
#
# Apply a per-project accent color to a tmux session's status bar.
#
# The accent is exposed to the theme as the `@accent` user option, which the
# status-left pill (the `#S` session-name badge) renders as its background. See
# project-accent.tmux for the wiring and the session-created hook.
#
# Usage:
#   project-accent.sh <session-id>   # apply to one session (called by the hook)
#   project-accent.sh                # backfill: apply to every current session
#
# The project -> color map is NOT defined here. It lives in a local, untracked
# file so your project names and color choices stay on your machine:
#
#   ~/.config/tmux/project-accent.local.sh   (gitignored)
#
# Copy project-accent.local.sh.example to that path and edit it. Without the
# local file, no session gets a custom accent (everything keeps the theme
# default), so this feature is a no-op for anyone who forks these dotfiles.

# Fallback: no per-project color until the local map redefines this.
accent_for() { printf '%s' ""; }

local_map="${XDG_CONFIG_HOME:-${HOME}/.config}/tmux/project-accent.local.sh"
# shellcheck source=/dev/null
[ -r "${local_map}" ] && . "${local_map}"

apply_one() {
  local session="$1" name color
  name="$(tmux display-message -p -t "${session}" '#{session_name}' 2>/dev/null)" || return 0
  [ -n "${name}" ] || return 0
  color="$(accent_for "${name}")"
  [ -n "${color}" ] && tmux set-option -t "${session}" @accent "${color}"
  return 0
}

if [ "$#" -ge 1 ]; then
  apply_one "$1"
else
  while IFS= read -r session; do
    apply_one "${session}"
  done < <(tmux list-sessions -F '#{session_id}' 2>/dev/null)
fi
