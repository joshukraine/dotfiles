# TokyoNight colors for Tmux

# Accent color for the status-bar pills (the session pill on the left and the
# host pill on the right). Parameterized so the per-project feature can override
# it per session via the @accent user option (see project-accent.tmux). The
# default keeps the stock TokyoNight Moon blue, so this theme renders correctly
# on its own. If you port these tweaks to another theme, parameterize that
# theme's pills the same way.
set -g @accent "#82aaff"

set -g mode-style "fg=#82aaff,bg=#3b4261"

set -g message-style "fg=#82aaff,bg=#3b4261"
set -g message-command-style "fg=#82aaff,bg=#3b4261"

set -g pane-border-style "fg=#3b4261"
set -g pane-active-border-style "fg=#82aaff"

set -g status "on"
set -g status-justify "left"

set -g status-style "fg=#82aaff,bg=#1e2030"

set -g status-left-length "100"
set -g status-right-length "100"

set -g status-left-style NONE
set -g status-right-style NONE

set -g status-left "#[fg=#1b1d2b,bg=#{@accent},bold] #S #[fg=#{@accent},bg=#1e2030,nobold,nounderscore,noitalics]"
set -g status-right "#[fg=#1e2030,bg=#1e2030,nobold,nounderscore,noitalics]#[fg=#82aaff,bg=#1e2030] #{prefix_highlight} #[fg=#3b4261,bg=#1e2030,nobold,nounderscore,noitalics]#[fg=#82aaff,bg=#3b4261] %Y-%m-%d  %I:%M %p #[fg=#{@accent},bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#1b1d2b,bg=#{@accent},bold] #h "
if-shell '[ "$(tmux show-option -gqv "clock-mode-style")" == "24" ]' {
  set -g status-right "#[fg=#1e2030,bg=#1e2030,nobold,nounderscore,noitalics]#[fg=#82aaff,bg=#1e2030] #{prefix_highlight} #[fg=#3b4261,bg=#1e2030,nobold,nounderscore,noitalics]#[fg=#82aaff,bg=#3b4261] %Y-%m-%d  %H:%M #[fg=#{@accent},bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#1b1d2b,bg=#{@accent},bold] #h "
}

setw -g window-status-activity-style "underscore,fg=#828bb8,bg=#1e2030"
setw -g window-status-separator ""
setw -g window-status-style "NONE,fg=#828bb8,bg=#1e2030"
setw -g window-status-format "#[fg=#1e2030,bg=#1e2030,nobold,nounderscore,noitalics]#[default] #I  #W #F #[fg=#1e2030,bg=#1e2030,nobold,nounderscore,noitalics]"
setw -g window-status-current-format "#[fg=#1e2030,bg=#3b4261,nobold,nounderscore,noitalics]#[fg=#82aaff,bg=#3b4261,bold] #I  #W #F #[fg=#3b4261,bg=#1e2030,nobold,nounderscore,noitalics]"

# tmux-plugins/tmux-prefix-highlight support
set -g @prefix_highlight_output_prefix "#[fg=#ffc777]#[bg=#1e2030]#[fg=#1e2030]#[bg=#ffc777]"
set -g @prefix_highlight_output_suffix ""
