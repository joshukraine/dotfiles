#  https://fishshell.com/docs/current/index.html

# set fish_greeting # supress fish greeting

if test (arch) = arm64
    eval (/opt/homebrew/bin/brew shellenv)
else
    eval (/usr/local/bin/brew shellenv)
end

# Environment variables - https://fishshell.com/docs/current/cmds/set.html
set -gx EDITOR nvim
set -gx GIT_EDITOR nvim
set -gx BUNDLER_EDITOR $EDITOR
set -gx MANPAGER 'less -X' # Don’t clear the screen after quitting a manual page
set -gx HOMEBREW_CASK_OPTS '--appdir=/Applications'
set -gx SOURCE_ANNOTATION_DIRECTORIES spec
set -gx RUBY_CONFIGURE_OPTS "--with-opt-dir=$HOMEBREW_PREFIX/opt/openssl:$HOMEBREW_PREFIX/opt/readline:$HOMEBREW_PREFIX/opt/libyaml:$HOMEBREW_PREFIX/opt/gdbm"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx DOTFILES "$HOME/dotfiles"
set -gx RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"
set -gx SSH_AUTH_SOCK "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# FZF specific - https://github.com/junegunn/fzf#key-bindings-for-command-line
set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --no-ignore-vcs'
set -gx FZF_DEFAULT_OPTS '--height 75% --layout=reverse --border'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx FZF_ALT_C_COMMAND 'fd --type d . --color=never'

fish_vi_key_bindings

if status is-interactive
    source $XDG_CONFIG_HOME/fish/abbreviations.fish
    source $XDG_CONFIG_HOME/fish/colors.fish

    # https://github.com/starship/starship#fish
    starship init fish | source

    # https://github.com/ajeetdsouza/zoxide
    zoxide init fish | source

    if test -e $HOME/.secrets/config.fish.local
        source $HOME/.secrets/config.fish.local
    end
end

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.fish ]; and . ~/.config/tabtab/__tabtab.fish; or true

source ~/.asdf/asdf.fish

# Configure npm to use asdf's Node for global packages
if command -v npm >/dev/null
    set -gx npm_config_prefix (dirname (dirname (which node)))
end

set OP_PLUGINS "$HOME/.config/op"

if test -d "$OP_PLUGINS"
    source ~/.config/op/plugins.sh
else
    echo "Directory does not exist: $OP_PLUGINS. Please reference https://developer.1password.com/docs/cli for installation instructions."
end
