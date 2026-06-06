# Per-project status accent
#
# Recolors the session-name pill (status-left) and the hostname pill
# (status-right) per session, so each tmux session — one per project, created
# via `tat` — shows a distinct color on both ends of the status bar.
#
# Mechanism:
#   - The theme (themes/tokyonight_moon.tmux) renders both pills from the
#     `@accent` user option and sets the default, so @accent is the single knob
#     that drives the accent color. Nothing here mirrors the theme's status
#     strings.
#   - The `session-created` hook runs scripts/project-accent.sh, which looks up
#     the project (by tmux session name) in the local map and sets a
#     session-level @accent. tmux resolves #{@accent} in each session's context,
#     so a session's pills take its color; unmatched sessions fall back to the
#     theme default.
#   - Add/remove projects by editing the case map in project-accent.local.sh
#     (your gitignored copy of project-accent.local.sh.example).
#
# Switching themes: parameterize the new theme's pills with #{@accent} the same
# way (see tokyonight_moon.tmux) — that is all this feature needs from a theme.

# Apply the project color whenever a session is created. Background the hook
# (-b) so it stays off tmux's command-queue critical path: a foreground
# run-shell here blocks the server while tmuxinator spawns a project's panes,
# adding shell-startup contention. The script's own `refresh-client -S` still
# paints the accent right away, so backgrounding costs no immediacy.
set-hook -g session-created 'run-shell -b "~/.config/tmux/scripts/project-accent.sh #{hook_session}"'

# ...and backfill any sessions that already exist when this file is (re)sourced.
run-shell "~/.config/tmux/scripts/project-accent.sh"
