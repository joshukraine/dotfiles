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
