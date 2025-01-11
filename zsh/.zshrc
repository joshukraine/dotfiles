. "$HOME/.config/zsh/profiler.start"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [ "$(arch)" = arm64 ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

export PATH="$HOME/.local/bin:$HOME/.bin:$PATH"
export EDITOR="nvim"
export GIT_EDITOR="nvim"
export BUNDLER_EDITOR=$EDITOR
export MANPAGER="less -X" # Don’t clear the screen after quitting a manual page
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export SOURCE_ANNOTATION_DIRECTORIES="spec"
export RUBY_CONFIGURE_OPTS="--with-opt-dir=$HOMEBREW_PREFIX/opt/openssl:$HOMEBREW_PREFIX/opt/readline:$HOMEBREW_PREFIX/opt/libyaml:$HOMEBREW_PREFIX/opt/gdbm"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export DOTFILES="$HOME/dotfiles"
export ABBR_USER_ABBREVIATIONS_FILE="$XDG_CONFIG_HOME/zsh-abbr/abbreviations.zsh"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
export PKG_CONFIG_PATH="/opt/homebrew/opt/libpq/lib/pkgconfig"
export GPG_TTY=$(tty)

. "$XDG_CONFIG_HOME/zsh/plugins.zsh" # Includes Zap - https://www.zapzsh.com
. "$XDG_CONFIG_HOME/zsh/aliases.zsh"
. "$XDG_CONFIG_HOME/zsh/functions.zsh"
. "$XDG_CONFIG_HOME/zsh/colors.zsh"
. "$XDG_CONFIG_HOME/zsh/docker.sh"
. "$HOME/.secrets/.zshrc.local"

export HISTSIZE=1000000000
export SAVEHIST=1000000000
export HISTFILE=~/.zsh_history
export HIST_STAMPS="yyyy-mm-dd"

# FZF specific - https://github.com/junegunn/fzf#key-bindings-for-command-line
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --no-ignore-vcs"
export FZF_DEFAULT_OPTS="--height 75% --layout=reverse --border"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_ALT_C_COMMAND="fd --type d . --color=never"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# homebrew completions
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Load and initialise completion system
autoload -Uz compinit && compinit

# De-dupe $PATH
typeset -U path

# GitHub Copilot CLI
if command -v gh >/dev/null && gh extension list | grep -q 'copilot'; then
  eval "$(gh copilot alias -- zsh)"
fi

. "$HOME/.config/zsh/profiler.stop"
