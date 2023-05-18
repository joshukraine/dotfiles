export PATH="$HOME/.local/bin:$HOME/.bin:$PATH"
export DOTFILES="$HOME/dotfiles"
export EDITOR="lvim"
export GIT_EDITOR="lvim"
export BUNDLER_EDITOR=$EDITOR
export MANPAGER="less -X" # Don’t clear the screen after quitting a manual page
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export DOTFILES="$HOME/dotfiles"
HOST_NAME=$(scutil --get HostName)
export HOST_NAME
export ABBR_USER_ABBREVIATIONS_FILE="$XDG_CONFIG_HOME/zsh-abbr/abbreviations.zsh"

if [ $(arch) = arm64 ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

eval "$(starship init zsh)"

# asdf
. $HOME/.asdf/asdf.sh

# 1password-cli
. $HOME/.config/op/plugins.sh

# zap
. $XDG_CONFIG_HOME/zsh/zap.zsh

source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh

typeset -A ZSH_HIGHLIGHT_REGEXP
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main regexp)

# ZSH_HIGHLIGHT_STYLES[builtin]='fg=#97FEA4'
# ZSH_HIGHLIGHT_STYLES[function]='fg=#97FEA4'
# ZSH_HIGHLIGHT_STYLES[command]='fg=#97FEA4'
# ZSH_HIGHLIGHT_STYLES[alias]='fg=#97FEA4'
# ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#79A070'
# ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#79A070'
# ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#F0776D'
# ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#F0776D'
# ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#FB649F'
# ZSH_HIGHLIGHT_STYLES[redirection]='fg=white'
# ZSH_HIGHLIGHT_STYLES[default]='fg=#7EBDB3'
# ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#F0776D'

ZSH_HIGHLIGHT_REGEXP=('^[[:blank:][:space:]]*('${(j:|:)${(Qk)ABBR_REGULAR_USER_ABBREVIATIONS}}')$' fg=blue)
ZSH_HIGHLIGHT_REGEXP+=('[[:<:]]('${(j:|:)${(Qk)ABBR_GLOBAL_USER_ABBREVIATIONS}}')$' fg=magenta)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
