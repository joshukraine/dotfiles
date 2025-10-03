#!/usr/bin/env bash

if [ "$(arch)" = arm64 ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi

export EDITOR="nvim"
export GIT_EDITOR="nvim"
export BUNDLER_EDITOR=$EDITOR
export MANPAGER="less -X" # Don’t clear the screen after quitting a manual page
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export DOTFILES="$HOME/dotfiles"

# FZF specific - https://github.com/junegunn/fzf#key-bindings-for-command-line
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --no-ignore-vcs"
export FZF_DEFAULT_OPTS="--height 75% --layout=reverse --border"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_ALT_C_COMMAND="fd --type d . --color=never"

alias c='clear'
alias cat='bat'
alias cp='cp -iv'
alias df='df -h'
alias du='du -h'
alias dud='du -d 1 -h'
alias duf='du -sh *'
alias l='eza -lhF'
alias la='eza -lahF'
alias ls='eza'
alias mkdir='mkdir -pv'
alias mv='mv -iv'

alias cdot='cd $DOTFILES'
alias cdxc='cd $XDG_CONFIG_HOME'
alias cdfi='cd $XDG_CONFIG_HOME/fish'
alias cdnv='cd $XDG_CONFIG_HOME/nvim'
alias cdxd='cd $XDG_DATA_HOME'
alias cdxa='cd $XDG_CACHE_HOME'
alias cdlb='cd $HOME/.local/bin'

function path() {
  echo "$PATH" | tr ":" "\n" | nl
}

function g() {
  if [[ $# -gt 0 ]]; then
    git "$@"
  else
    clear && git status --short --branch && echo
  fi
}

function pi() {
  ping -Anc 5 1.1.1.1
}

function src() {
  # shellcheck disable=SC1090
  source ~/.bashrc && echo 'source ~/.bashrc'
}

eval "$(starship init bash)"

# shellcheck disable=SC1091
# . "$HOME/.asdf/asdf.sh"
# shellcheck disable=SC1091
# . "$HOME/.asdf/completions/asdf.bash"

# shellcheck disable=SC1090
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# https://github.com/junegunn/fzf-git.sh
# Load fzf-git.sh for enhanced git operations with fuzzy finding
if [[ -f "$DOTFILES/bin/fzf-git.sh" ]]; then
  source "$DOTFILES/bin/fzf-git.sh"
fi

# vim: set filetype=bash:
