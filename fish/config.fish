#  https://fishshell.com/docs/current/index.html

set fish_greeting

# Environment variables - https://fishshell.com/docs/current/cmds/set.html
set -gx EDITOR 'lvim' # LunarVim
set -gx GIT_EDITOR 'lvim' # LunarVim
set -gx BUNDLER_EDITOR $EDITOR
set -gx MANPAGER 'less -X' # Don’t clear the screen after quitting a manual page
set -gx HOMEBREW_CASK_OPTS '--appdir=/Applications'
set -gx SOURCE_ANNOTATION_DIRECTORIES 'spec'
set -gx RUBY_CONFIGURE_OPTS '--with-opt-dir=/usr/local/opt/openssl:/usr/local/opt/readline:/usr/local/opt/libyaml:/usr/local/opt/gdbm'
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx DOTFILES "$HOME/dotfiles"
set -gx RIPGREP_CONFIG_PATH "$DOTFILES/ripgreprc"
set -gx HOST_NAME (scutil --get HostName)

# FZF specific - https://github.com/junegunn/fzf#key-bindings-for-command-line
set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --no-ignore-vcs'
set -gx FZF_DEFAULT_OPTS '--height 50% --layout=reverse --border'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx FZF_ALT_C_COMMAND 'fd --type d . --color=never'

fish_vi_key_bindings

if status is-interactive
  source $XDG_CONFIG_HOME/fish/abbreviations.fish

  # https://github.com/starship/starship#fish
  starship init fish | source

  if test -e $DOTFILES/machines/$HOST_NAME/colors.fish
    source $DOTFILES/machines/$HOST_NAME/colors.fish
  end

  if test -e $DOTFILES/local/config.fish.local
    source $DOTFILES/local/config.fish.local
  end
end

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.fish ]; and . ~/.config/tabtab/__tabtab.fish; or true

source ~/.asdf/asdf.fish
