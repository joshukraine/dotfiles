# Per-project status accent
#
# Recolors the session-name pill in status-left per session, so each tmux
# session (one per project, created via `tat`) shows a distinct color badge.
#
# Mechanism:
#   - `@accent` is a user option holding the pill's background color. The
#     status-left override below renders it; #{@accent} resolves per session.
#   - The `session-created` hook runs scripts/project-accent.sh, which looks up
#     the project (by directory basename) in its central map and sets @accent
#     for that session.
#   - Add/remove projects by editing the case map in scripts/project-accent.sh.
#
# NOTE: the status-left string below mirrors tokyonight_moon.tmux exactly,
# except the literal #82aaff becomes #{@accent}. If you switch themes, re-derive
# this line from the new theme — otherwise it imposes Moon's separator colors.

# Default accent = TokyoNight Moon blue (matches the stock theme)
set -g @accent "#82aaff"

# status-left with the session-name pill driven by @accent
set -g status-left "#[fg=#1b1d2b,bg=#{@accent},bold] #S #[fg=#{@accent},bg=#1e2030,nobold,nounderscore,noitalics]"

# Apply the project color whenever a session is created...
set-hook -g session-created 'run-shell "~/.config/tmux/scripts/project-accent.sh #{hook_session}"'

# ...and backfill any sessions that already exist when this file is (re)sourced.
run-shell "~/.config/tmux/scripts/project-accent.sh"
