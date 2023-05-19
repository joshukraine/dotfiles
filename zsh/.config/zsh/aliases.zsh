# General
alias cat='bat --paging=never'
alias cp='gcp -iv'

# ls > exa
# Other aliases handled by exa plugin
# https://github.com/zap-zsh/exa
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
alias saf='defaults write com.apple.finder AppleShowAllFiles TRUE; killall Finder'
alias haf='defaults write com.apple.finder AppleShowAllFiles FALSE; killall Finder'
alias o='open . &'
