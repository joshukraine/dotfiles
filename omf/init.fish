# PATH
set -xg PATH \
  "$HOME/bin" \
  '/usr/local/bin' \
  '/usr/local/sbin' \
  '/usr/bin' \
  '/bin' \
  '/usr/sbin' \
  '/sbin' \
  $PATH

# Environment variables - https://fishshell.com/docs/current/commands.html#set
set -xg EDITOR 'nvim'
set -xg BUNDLER_EDITOR $EDITOR
set -xg MANPAGER 'less -X' # Don’t clear the screen after quitting a manual page
set -xg HOMEBREW_CASK_OPTS '--appdir=/Applications'
set -xg SOURCE_ANNOTATION_DIRECTORIES 'spec'
set -xg RUBY_CONFIGURE_OPTS '--with-opt-dir=/usr/local/opt/openssl:/usr/local/opt/readline:/usr/local/opt/libyaml:/usr/local/opt/gdbm'
set -xg XDG_CONFIG_HOME "$HOME/.config"
set -xg XDG_DATA_HOME "$HOME/.local/share"
set -xg XDG_CACHE_HOME "$HOME/.cache"
set -xg TERM 'screen-256color'

. $OMF_CONFIG/aliases.fish
. $OMF_CONFIG/functions.fish
. $OMF_CONFIG/tmux.fish

fish_vi_key_bindings

# asdf
. $HOME/.asdf/asdf.fish

if test -e ~/.fish.local
  . ~/.fish.local
end
