. "$HOME/.config/zsh/profiler.start"

if [ "$(arch)" = arm64 ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

# brew shellenv exports FPATH, and zsh's core functions live at a version-pinned
# Cellar path — so a zsh upgrade leaves pre-upgrade processes (tmux server,
# terminal app) leaking a dead fpath entry into every new shell. Self-heal here,
# before plugins load: drop dead entries, re-add the version-agnostic path.
typeset -U fpath
# shellcheck disable=SC1036,SC1072,SC1073,SC1009
fpath=(${^fpath}(N-/))
# shellcheck disable=SC1036,SC1072,SC1073,SC1009
fpath+=("${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh/functions"(N-/))

export PATH="/opt/homebrew/opt/trash/bin:/opt/homebrew/opt/postgresql@17/bin:${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$HOME/.local/bin:$HOME/.bin:$PATH"

# Shared environment variables
source "$HOME/dotfiles/shared/environment.sh"

# Zsh-specific environment variables
export ABBR_USER_ABBREVIATIONS_FILE="$XDG_CONFIG_HOME/zsh-abbr/abbreviations.zsh"
export PKG_CONFIG_PATH="/opt/homebrew/opt/libpq/lib/pkgconfig"
export GPG_TTY=$(tty)

. "$XDG_CONFIG_HOME/zsh/plugins.zsh" # Includes Zap - https://www.zapzsh.com
. "$XDG_CONFIG_HOME/zsh/aliases.zsh"
. "$XDG_CONFIG_HOME/zsh/functions.zsh"
. "$XDG_CONFIG_HOME/zsh/cc-functions.zsh"
. "$XDG_CONFIG_HOME/zsh/colors.zsh"
. "$XDG_CONFIG_HOME/zsh/docker.sh"
. "$HOME/.zshrc.local"

# Configure npm to use asdf's Node for global packages
if command -v asdf >/dev/null; then
    export npm_config_prefix="$(asdf where nodejs 2>/dev/null)"
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
fpath=($HOME/.docker/completions $fpath)

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

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

# Keep the alias layer away from agents.
#
# Aliases are the human presentation layer: pretty output, muscle memory. Coding
# agents (Claude Code) run non-interactive shells that want the opposite — plain,
# parse-stable output. Abbreviations already can't reach agents (expansion needs
# ZLE), but aliases do: Claude Code snapshots the shell and replays it into every
# tool call. Dropping them here means an agent sees /bin/ls, not eza.
#
# This works because that snapshot is taken from a LOGIN, NON-INTERACTIVE shell —
# verified, not assumed: its recorded options include `login` but not `interactive`,
# and its captured function set matches a non-interactive source exactly (74 vs the
# 96 an interactive one yields).
#
# Must stay last. Aliases arrive from three places — plugins.zsh (the exa plugin
# defines ls/ll/la/tree), aliases.zsh, and .zshrc.local — and only a sweep after
# all of them catches every one. Guarding an individual block instead would leave
# the plugin's own `ls` alive for agents.
#
# Functions and environment are untouched, so gcom/gpum/grbm, PATH, and asdf shims
# all still work for agents.
[[ -o interactive ]] || unalias -a
