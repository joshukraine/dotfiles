set fish_greeting

# Environment variables - https://fishshell.com/docs/current/cmds/set.html
set -xg EDITOR 'nvim'
set -xg BUNDLER_EDITOR $EDITOR
set -xg MANPAGER 'less -X' # Don’t clear the screen after quitting a manual page
set -xg HOMEBREW_CASK_OPTS '--appdir=/Applications'
set -xg SOURCE_ANNOTATION_DIRECTORIES 'spec'
set -xg RUBY_CONFIGURE_OPTS '--with-opt-dir=/usr/local/opt/openssl:/usr/local/opt/readline:/usr/local/opt/libyaml:/usr/local/opt/gdbm'
set -xg XDG_CONFIG_HOME "$HOME/.config"
set -xg XDG_DATA_HOME "$HOME/.local/share"
set -xg XDG_CACHE_HOME "$HOME/.cache"
set -xg DOTFILES "$HOME/dotfiles"
set -xg FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --glob "!.git/*"'
set -xg HOST_NAME (scutil --get HostName)

fish_vi_key_bindings

if status is-interactive
  source $XDG_CONFIG_HOME/fish/abbreviations.fish

  # https://github.com/starship/starship#fish
  starship init fish | source

  # https://asdf-vm.com/#/core-manage-asdf-vm?id=add-to-your-shell
  source ~/.asdf/asdf.fish

  if test -e $DOTFILES/machines/$HOST_NAME/colors.fish
    source $DOTFILES/machines/$HOST_NAME/colors.fish
  end

  if test -e $DOTFILES/local/config.fish.local
    source $DOTFILES/local/config.fish.local
  end
end
