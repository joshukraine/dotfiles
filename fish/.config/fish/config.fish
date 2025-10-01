#  https://fishshell.com/docs/current/index.html

# set fish_greeting # supress fish greeting

if test (arch) = arm64
    eval (/opt/homebrew/bin/brew shellenv)
else
    eval (/usr/local/bin/brew shellenv)
end

# Shared environment variables
source "$HOME/dotfiles/shared/environment.fish"

fish_vi_key_bindings

if status is-interactive
    source $XDG_CONFIG_HOME/fish/abbreviations.fish
    source $XDG_CONFIG_HOME/fish/colors.fish

    # https://github.com/starship/starship#fish
    starship init fish | source

    # https://github.com/ajeetdsouza/zoxide
    zoxide init fish | source

    # https://github.com/junegunn/fzf-git.sh
    # Load fzf-git.sh for enhanced git operations with fuzzy finding
    if test -f $DOTFILES/bin/fzf-git.sh
        source $DOTFILES/bin/fzf-git.sh
        
    # fzf integration
    # https://github.com/junegunn/fzf#using-homebrew-or-linuxbrew
    if command -v fzf >/dev/null
        if test -f (brew --prefix)/opt/fzf/shell/key-bindings.fish
            source (brew --prefix)/opt/fzf/shell/key-bindings.fish
        end
    end

    if test -e $HOME/.secrets/config.fish.local
        source $HOME/.secrets/config.fish.local
    end
end

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.fish ]; and . ~/.config/tabtab/__tabtab.fish; or true

# Load asdf version manager
if test -f ~/.asdf/asdf.fish
    source ~/.asdf/asdf.fish
else if test -f /opt/homebrew/opt/asdf/libexec/asdf.fish
    source /opt/homebrew/opt/asdf/libexec/asdf.fish
end

# Configure npm to use asdf's Node for global packages
if command -v npm >/dev/null
    set -gx npm_config_prefix (dirname (dirname (which node)))
end

# Load 1Password CLI plugins if available
set OP_PLUGINS_FILE "$HOME/.config/op/plugins.sh"

if test -f "$OP_PLUGINS_FILE"
    source "$OP_PLUGINS_FILE"
end
