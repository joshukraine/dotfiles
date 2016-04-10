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

plugins=(git brew rails)

source $ZSH/oh-my-zsh.sh
# }}}

# Aliases {{{

# Vim specific
alias vi='vim'
alias vir='vim -R'
alias vv='vim --version | less'
alias ct='ctags -R --languages=ruby --exclude=.git --exclude=log . $(bundle list --paths)'

# Jump to quick edits
alias ez='vim ~/.zshrc'
alias ed='vim ~/dotfiles'
alias ev='vim ~/.vimrc'

# General UNIX
alias mv='mv -iv'
alias cp='cp -iv'
alias srm='srm -iv'
alias df='df -h'
alias du='du -h'
alias mkdir='mkdir -pv'
alias src='source ~/.zshrc'
alias pi='ping -Anc 5 8.8.8.8'
alias path='echo -e ${PATH//:/\\n}'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias .2='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'
alias lsa='ls -lahF'
alias l='ls -lahF'
alias ll='ls -lhF'
alias la='ls -lAhF'
alias lf='ls -F'
alias lh='ls -d .*'

# Tree
alias t1='tree -CFL 1'
alias t2='tree -CFL 2'
alias t3='tree -CFL 3'
alias t4='tree -CFL 4'

alias t1a='tree -CFLa 1'
alias t2a='tree -CFLa 2'
alias t3a='tree -CFLa 3'
alias t4a='tree -CFLa 4'

# Upgrade Oh My Zshell
alias upz='upgrade_oh_my_zsh'

# Show/Hide hidden files in Finder
alias saf='defaults write com.apple.finder AppleShowAllFiles TRUE; killall Finder'
alias haf='defaults write com.apple.finder AppleShowAllFiles FALSE; killall Finder'

# Rails (more are defined in the oh-my-zsh rails plugin)
alias bx='bundle exec'
alias sst='spring status'

# Middleman
alias ms='bundle exec middleman server'
alias msg='bundle exec middleman server -e gulp'
alias mc='bundle exec middleman console'
alias mb='bundle exec middleman build --clean'

# Postgres
alias startpost='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias stoppost='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log stop'
alias statpost='ps aux | ag postgres'
alias psq='psql -d postgres'

# Homebrew
alias bu='brew update'
alias bg='brew upgrade --all'
alias bo='brew outdated'
alias bd='brew doctor'
alias bc='brew cleanup'

# rbenv
alias rbv='rbenv versions'
alias rbl='rbenv install -l | ag "^\s+[0-9].*" --nocolor'

# Finder
alias o='open . &'

# Check for OS X updates
alias upc='softwareupdate -l'

# Download and install OS X updates
alias upd='softwareupdate -i -a'

# Misc
alias color='colortest -w -s'
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

# Get the name of the branch we are on
# Adapted from git_prompt_info(), .oh-my-zsh/lib/git.zsh
function my_git_branch() {
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo " $(git_commits_ahead)$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$(git_prompt_status)$ZSH_THEME_GIT_PROMPT_SUFFIX"
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
