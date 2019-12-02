# PATH
set PATH '/usr/local/sbin' $PATH
set PATH '/usr/local/bin' $PATH
set PATH "$HOME/bin" $PATH

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

. $OMF_CONFIG/abbreviations.fish

fish_vi_key_bindings

# https://github.com/starship/starship#fish
starship init fish | source

# asdf
. $HOME/.asdf/asdf.fish

if test -e ~/.fish.local
  . ~/.fish.local
end
