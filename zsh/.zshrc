. $HOME/.config/zsh/profiler.start

if [ $(arch) = arm64 ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

export PATH="$HOME/.local/bin:$HOME/.bin:$PATH"
export EDITOR="lvim" # LunarVim
export GIT_EDITOR="lvim" # LunarVim
export BUNDLER_EDITOR=$EDITOR
export MANPAGER="less -X" # Don’t clear the screen after quitting a manual page
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export SOURCE_ANNOTATION_DIRECTORIES="spec"
export RUBY_CONFIGURE_OPTS="--with-opt-dir=$HOMEBREW_PREFIX/opt/openssl:$HOMEBREW_PREFIX/opt/readline:$HOMEBREW_PREFIX/opt/libyaml:$HOMEBREW_PREFIX/opt/gdbm"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export DOTFILES="$HOME/dotfiles"
export HOST_NAME=$(scutil --get HostName)
export ABBR_USER_ABBREVIATIONS_FILE="$XDG_CONFIG_HOME/zsh-abbr/abbreviations.zsh"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# FZF specific - https://github.com/junegunn/fzf#key-bindings-for-command-line
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --no-ignore-vcs"
export FZF_DEFAULT_OPTS="--height 75% --layout=reverse --border"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_ALT_C_COMMAND="fd --type d . --color=never"

HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history
HIST_STAMPS="yyyy-mm-dd"

. $XDG_CONFIG_HOME/zsh/plugins.zsh # Includes Zap - https://www.zapzsh.org
. $XDG_CONFIG_HOME/zsh/aliases.zsh
. $XDG_CONFIG_HOME/zsh/functions.zsh
. $XDG_CONFIG_HOME/zsh/colors.zsh

# Load and initialise completion system
autoload -Uz compinit && compinit

# De-dupe $PATH
typeset -U path

. $HOME/.config/zsh/profiler.stop
