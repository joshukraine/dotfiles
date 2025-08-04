. "$HOME/.config/zsh/profiler.start"

if [ "$(arch)" = arm64 ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$HOME/.local/bin:$HOME/.bin:$PATH"

# Shared environment variables
source "$HOME/dotfiles/shared/environment.sh"

# Zsh-specific environment variables
export ABBR_USER_ABBREVIATIONS_FILE="$XDG_CONFIG_HOME/zsh-abbr/abbreviations.zsh"
export PKG_CONFIG_PATH="/opt/homebrew/opt/libpq/lib/pkgconfig"
export GPG_TTY=$(tty)

. "$XDG_CONFIG_HOME/zsh/plugins.zsh" # Includes Zap - https://www.zapzsh.com
. "$XDG_CONFIG_HOME/zsh/aliases.zsh"
. "$XDG_CONFIG_HOME/zsh/functions.zsh"
. "$XDG_CONFIG_HOME/zsh/colors.zsh"
. "$XDG_CONFIG_HOME/zsh/docker.sh"
. "$HOME/.zshrc.local"

# Configure npm to use asdf's Node for global packages
if command -v npm >/dev/null; then
    export npm_config_prefix=$(dirname $(dirname $(which node)))
fi

# History configuration
export HISTSIZE=1000000000
export SAVEHIST=1000000000
export HISTFILE=~/.zsh_history

# History options for timestamps and better behavior
setopt EXTENDED_HISTORY          # Record timestamp of command in history file
setopt HIST_EXPIRE_DUPS_FIRST    # Delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_IGNORE_DUPS          # Ignore duplicated commands history list
setopt HIST_IGNORE_SPACE         # Ignore commands that start with space
setopt HIST_VERIFY               # Show command with history expansion to user before running it
setopt INC_APPEND_HISTORY        # Add commands to HISTFILE in order of execution
setopt SHARE_HISTORY             # Share command history data


# homebrew completions
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Docker CLI completions
fpath=(/Users/joshukraine/.docker/completions $fpath)

# Load and initialise completion system with caching for performance
autoload -Uz compinit
# shellcheck disable=SC1036,SC1072,SC1073,SC1009
if [[ -n "${ZDOTDIR:-${HOME}}"/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# De-dupe $PATH
typeset -U path

# GitHub Copilot CLI (lazy load for performance)
if command -v gh >/dev/null 2>&1; then
  gh_copilot_lazy() {
    if gh extension list 2>/dev/null | grep -q 'copilot'; then
      eval "$(gh copilot alias -- zsh)"
      unfunction gh_copilot_lazy
    fi
  }
  alias ghcs="gh_copilot_lazy && ghcs"
  alias ghce="gh_copilot_lazy && ghce"
fi

. "$HOME/.config/zsh/profiler.stop"
