# Nord colors for Tmux

# Accent color for the status-bar pills (the session pill on the left and the
# host pill on the right). Parameterized so the per-project feature can override
# it per session via the @accent user option (see project-accent.tmux). The
# default is Nord's frost blue, so this theme renders correctly on its own.
set -g @accent "#88c0d0"

set -g mode-style "fg=#88c0d0,bg=#3b4252"

set -g message-style "fg=#88c0d0,bg=#3b4252"
set -g message-command-style "fg=#88c0d0,bg=#3b4252"

set -g pane-border-style "fg=#4c566a"
set -g pane-active-border-style "fg=#88c0d0"

set -g status "on"
set -g status-justify "left"

set -g status-style "fg=#d8dee9,bg=#2e3440"

set -g status-left-length "100"
set -g status-right-length "100"

set -g status-left-style NONE
set -g status-right-style NONE

set -g status-left "#[fg=#2e3440,bg=#{@accent},bold] #S #[fg=#{@accent},bg=#2e3440,nobold,nounderscore,noitalics]"
set -g status-right "#[fg=#2e3440,bg=#2e3440,nobold,nounderscore,noitalics]#[fg=#88c0d0,bg=#2e3440] #{prefix_highlight} #[fg=#4c566a,bg=#2e3440,nobold,nounderscore,noitalics]#[fg=#d8dee9,bg=#4c566a] %Y-%m-%d  %I:%M %p #[fg=#{@accent},bg=#4c566a,nobold,nounderscore,noitalics]#[fg=#2e3440,bg=#{@accent},bold] #h "
if-shell '[ "$(tmux show-option -gqv "clock-mode-style")" == "24" ]' {
  set -g status-right "#[fg=#2e3440,bg=#2e3440,nobold,nounderscore,noitalics]#[fg=#88c0d0,bg=#2e3440] #{prefix_highlight} #[fg=#4c566a,bg=#2e3440,nobold,nounderscore,noitalics]#[fg=#d8dee9,bg=#4c566a] %Y-%m-%d  %H:%M #[fg=#{@accent},bg=#4c566a,nobold,nounderscore,noitalics]#[fg=#2e3440,bg=#{@accent},bold] #h "
}

setw -g window-status-activity-style "underscore,fg=#ebcb8b,bg=#2e3440"
setw -g window-status-separator ""
setw -g window-status-style "NONE,fg=#d8dee9,bg=#2e3440"
setw -g window-status-format "#[fg=#2e3440,bg=#2e3440,nobold,nounderscore,noitalics]#[default] #I  #W #F #[fg=#2e3440,bg=#2e3440,nobold,nounderscore,noitalics]"
setw -g window-status-current-format "#[fg=#2e3440,bg=#4c566a,nobold,nounderscore,noitalics]#[fg=#88c0d0,bg=#4c566a,bold] #I  #W #F #[fg=#4c566a,bg=#2e3440,nobold,nounderscore,noitalics]"

# tmux-plugins/tmux-prefix-highlight support
set -g @prefix_highlight_output_prefix "#[fg=#ebcb8b]#[bg=#2e3440]#[fg=#2e3440]#[bg=#ebcb8b]"
set -g @prefix_highlight_output_suffix ""
