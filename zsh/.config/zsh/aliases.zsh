# General
alias cat='bat --paging=never'
alias cp='gcp -iv'

# ls > eza
# Other aliases handled by exa plugin
# https://github.com/zap-zsh/exa (now uses eza)
alias l='ll'

# Middleman
alias mm='bundle exec middleman'
alias mms='bundle exec middleman server'
alias mmc='bundle exec middleman console -e console'
alias mmb='bundle exec middleman build --clean'
alias mma='bundle exec middleman article'

# Postgres
alias psq='pgcli -d postgres'
alias startpost='brew services start postgresql'
alias statpost='ps aux | rg postgres'
alias stoppost='brew services stop postgresql'

# Mac App Store (https://github.com/argon/mas)
alias masi='mas install'
alias masl='mas list'
alias maso='mas outdated'
alias mass='mas search'
alias masu='mas upgrade'

# Finder
# You can also toggle hidden files from the Finder GUI with Cmd + Shift + .
alias saf='defaults write com.apple.finder AppleShowAllFiles TRUE; killall Finder'
alias haf='defaults write com.apple.finder AppleShowAllFiles FALSE; killall Finder'
alias o='open . &'

# Tmux
alias tmux='tmux -u'
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'

# Vim
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# Exa
alias ll='exa -al --color=always --git'
alias l='exa -a --color=always --git'
alias ls='exa --color=always --git'

# Path's
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias temp='cd /Volumes/book-dev/temp'

# Zsh
alias zshconfig='code ~/.zshrc'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gco='git checkout'
alias gb='git branch'
alias gba='git branch -a'
alias gbr='git branch -r'
alias gpush='git push origin main'
alias gpull='git pull origin main'
alias glog='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gdc='git diff --cached'
alias gds='git diff --staged'
alias gl='git pull'
alias gpl='git pull origin main'

