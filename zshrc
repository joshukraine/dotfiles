# Exports {{{
export PATH=$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/go/bin
export EDITOR="vim"
export BUNDLER_EDITOR="vim"
export MANPAGER="less -X" # Don’t clear the screen after quitting a manual page
export TERM="screen-256color"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export SOURCE_ANNOTATION_DIRECTORIES="spec"
# }}}

# oh-my-zsh {{{
export ZSH=$HOME/.oh-my-zsh
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE=true
COMPLETION_WAITING_DOTS="true"

plugins=(git brew rails osx)

source $ZSH/oh-my-zsh.sh
# }}}

# Aliases {{{
source $HOME/dotfiles/zsh/aliases
# }}}

# Ruby {{{
function get_ruby_version() {
  if command -v ruby >/dev/null; then
    ruby -v | awk '{print $1 " " $2}'
  else
    echo "Ruby not installed"
  fi
}
# }}}

# Prompt {{{

# Echo commits ahead only if remote exists.
function my_remote_status() {
  if [[ -n "$(command git show-ref origin/$(git_current_branch) 2> /dev/null)" ]]; then
    echo "$(git_commits_ahead)"
  fi
}

# Get the name of the branch we are on
# Adapted from git_prompt_info(), .oh-my-zsh/lib/git.zsh
function my_git_branch() {
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo " $(my_remote_status)$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$(git_prompt_status)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX="%{$fg[magenta]%}↑"
ZSH_THEME_GIT_COMMITS_AHEAD_SUFFIX="%{$fg[white]%} "

ZSH_THEME_GIT_PROMPT_PREFIX="["
ZSH_THEME_GIT_PROMPT_SUFFIX="]"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_AHEAD=""
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}+%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[red]%}*%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}-%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%}>%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}═%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}#%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$fg[reset_color]%}"

local user='%{$fg[green]%}%m:%{$reset_color%}'
local ssh_user='%{$fg[magenta]%}%n@%m:%{$reset_color%}'
local pwd='%{$fg[blue]%}%~%{$reset_color%}'
local git='$(git_prompt_short_sha)%{$fg[white]%}$(my_git_branch)%{$reset_color%}'

_rubyprompt() {
  if [ $COLUMNS -gt 80 ]; then
    echo "$(get_ruby_version)"
  fi
}

if [[ -n $SSH_CONNECTION ]]; then
  PROMPT="${ssh_user}${pwd}${git}
%(?..%{$fg[red]%})%B%%%b "
else
  PROMPT="${pwd}${git}
%(?.%{$fg[green]%}.%{$fg[red]%})%B%%%b "
fi

setopt transient_rprompt # only show the rprompt on the current prompt

RPROMPT='$(_rubyprompt)'
# }}}

# Tmux {{{
# Makes creating a new tmux session (with a specific name) easier
function tn() {
  tmux new -s $1
}

# Makes attaching to an existing tmux session (with a specific name) easier
function ta() {
  tmux attach -t $1
}

# Makes deleting a tmux session easier
function tk() {
  tmux kill-session -t $1
}

# List tmux sessions
alias tl='tmux ls'

# Create a new session named for current directory, or attach if exists.
alias tna='tmux new-session -As $(basename "$PWD" | tr . -)'

# Source .tmux.conf
alias tsrc="tmux source-file ~/.tmux.conf"

# Kill all tmux sessions
alias tka="tmux ls | cut -d : -f 1 | xargs -I {} tmux kill-session -t {}" # tmux kill all sessions

# Always in tmux :)
_not_inside_tmux() { [[ -z "$TMUX" ]] }

ensure_tmux_is_running() {
  if _not_inside_tmux; then
    tat
  fi
}

ensure_tmux_is_running

source ~/bin/tmuxinator.zsh
# }}}

# History {{{
HISTSIZE=20000
SAVEHIST=20000
HISTFILE=~/.zsh_history
# }}}

# cdpath {{{
setopt auto_cd
cdpath=($HOME/code $HOME/Developer $HOME/Sites $HOME/vms $HOME/Dropbox $HOME)
# }}}

# functions {{{
randpw() {
  openssl rand -base64 4 | md5 | head -c$1 ; echo
}

# Determine size of a file or total size of a directory
# Thank you, Mathias! https://raw.githubusercontent.com/mathiasbynens/dotfiles/master/.functions
function fs() {
  if du -b /dev/null > /dev/null 2>&1; then
    local arg=-sbh;
  else
    local arg=-sh;
  fi
  if [[ -n "$@" ]]; then
    du $arg -- "$@";
  else
    du $arg .[^.]* *;
  fi;
}

function conflicted { vim +Conflicted }

function vundle_update { vim +PluginUpdate +qall }

# }}}

# Rbenv {{{
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
# }}}

# Include local settings {{{
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
# }}}

# Travis CI {{{
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh
# }}}

# NVM {{{
export NVM_DIR="/Users/joshukraine/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
# }}}
