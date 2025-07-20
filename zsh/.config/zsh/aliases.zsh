# General
alias cat='bat --paging=never'
alias cp='gcp -iv'

# Alwyas use Neovim as EDITOR
alias vim='nvim'

# ls > eza  
# Other aliases handled by exa plugin (uses eza under the hood)
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
# You can also toggle hidden files from the Finder GUI with Cmd + Shift + .
alias saf='defaults write com.apple.finder AppleShowAllFiles TRUE; killall Finder'
alias haf='defaults write com.apple.finder AppleShowAllFiles FALSE; killall Finder'
alias o='open . &'

# Neovim
# https://github.com/richin13/asdf-neovim
alias update-nvim-stable='asdf uninstall neovim stable && asdf install neovim stable'
alias update-nvim-nightly='asdf uninstall neovim nightly && asdf install neovim nightly'
# alias update-nvim-master='asdf uninstall neovim ref:master && asdf install neovim ref:master'

# https://github.com/nickjj/docker-rails-example/blob/main/run
alias run='./run'
