# Shared environment variables for Fish shell
# This file mirrors environment.sh but uses Fish syntax
# Keep manually synchronized with shared/environment.sh

# Editor configuration
set -gx EDITOR nvim
set -gx GIT_EDITOR nvim
set -gx BUNDLER_EDITOR $EDITOR

# Manual page configuration
set -gx MANPAGER 'less -X'  # Don't clear the screen after quitting a manual page

# Homebrew configuration
set -gx HOMEBREW_CASK_OPTS '--appdir=/Applications'

# Development configuration
set -gx SOURCE_ANNOTATION_DIRECTORIES spec
set -gx RUBY_CONFIGURE_OPTS "--with-opt-dir=$HOMEBREW_PREFIX/opt/openssl:$HOMEBREW_PREFIX/opt/readline:$HOMEBREW_PREFIX/opt/libyaml:$HOMEBREW_PREFIX/opt/gdbm"

# XDG Base Directory Specification
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_STATE_HOME "$HOME/.local/state"

# Dotfiles and configuration paths
set -gx DOTFILES "$HOME/dotfiles"
set -gx RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"

# 1Password SSH agent
set -gx SSH_AUTH_SOCK "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# FZF configuration
set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --no-ignore-vcs'
set -gx FZF_DEFAULT_OPTS '--height 75% --layout=reverse --border'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx FZF_ALT_C_COMMAND 'fd --type d . --color=never'