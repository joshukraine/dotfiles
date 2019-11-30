# General UNIX
alias mkdir 'mkdir -pv'
alias pi 'ping -Anc 5 1.1.1.1'
alias src 'exec fish'
alias ls 'exa'
alias l 'exa -lhF'
alias la 'exa -lahF'

# Jump to quick edits
alias ea "$EDITOR ~/dotfiles/omf/aliases.fish"
alias ed "$EDITOR ~/dotfiles"
alias et "$EDITOR ~/.tmux.conf"
alias ev "$EDITOR $XDG_CONFIG_HOME/nvim/init.vim"
alias evl "$EDITOR ~/.vimrc.local"
alias efl "$EDITOR ~/.fish.local"

# Git
alias gbrm 'git branch --merged master | grep -v "^\*\|  master" | xargs -n 1 git branch -d'
alias gdf 'git diff --word-diff --color-words'
alias gds 'git diff --word-diff --cached --color-words'
alias gl 'git log --date=format:"%b %d, %Y" --pretty=format:"%C(yellow bold)%h%Creset%C(white)%d%Creset %s%n %C(blue)%aN (%cd)%n"'
alias glg 'git log --graph --stat --pretty=format:"%C(yellow bold)%h%Creset%C(white)%d%Creset %s%n %C(blue)%aN (%cd)%n"'
alias gtl 'git tag --list | sort -r'
alias gwip 'git add -A; git rm (git ls-files --deleted) 2> /dev/null; git commit --no-verify -m "--wip--"'

# Rails
alias RED='RAILS_ENV=development'
alias REP='RAILS_ENV=production'
alias RET='RAILS_ENV=test'
alias bx 'bundle exec'
alias crsp 'COVERAGE=true rake spec'
alias fos 'foreman start'
alias hl 'haml-lint'
# alias mina '_mina_command'
alias om 'overmind start'
alias psp 'bundle exec rake parallel:spec'
# alias rails '_rails_command'
alias rc 'rails console'
alias rcop 'rubocop'
alias rdb 'rails dbconsole'
alias rddd 'brew services restart postgresql; sleep 15; rails db:drop'
alias rdm 'rails db:migrate'
alias rgm 'rails generate migration'
alias rs 'rails server'
alias rsp 'rspec .'
# alias rspec '_rspec_command'
alias rsr 'rails restart'
alias rtp 'rails db:test:prepare'
# alias spring '_spring_command'
alias sps 'spring stop'
alias sst 'spring status'

# Middleman
alias mm 'bundle exec middleman'
alias mms 'bundle exec middleman server'
alias mmc 'bundle exec middleman console -e console'
alias mmb 'bundle exec middleman build --clean'
alias mma 'bundle exec middleman article'

# Postgres
alias psq 'pgcli -d postgres'
alias startpost 'brew services start postgresql'
alias statpost 'ps aux | rg postgres'
alias stoppost 'brew services stop postgresql'

# Homebrew
alias bubc 'brew upgrade; and brew cleanup'
alias bubo 'brew update; and brew outdated'

# asdf
alias aua 'asdf update; and asdf plugin-update --all'
alias ala 'asdf list-all'
alias rlv "asdf list-all ruby | rg '^\d'"

# https://fishshell.com/docs/current/commands.html#fish_update_completions
alias ucl 'fish_update_completions'

# Finder
alias saf 'defaults write com.apple.finder AppleShowAllFiles TRUE; killall Finder'
alias haf 'defaults write com.apple.finder AppleShowAllFiles FALSE; killall Finder'
alias o 'open . &'
alias dsstore_bye_bye 'find . -name "*.DS_Store" -type f -delete'
alias defr 'defaults read'
alias defw 'defaults write'

# Check for macOS updates
alias upc 'softwareupdate -l'

# Download and install macOS updates
alias upd 'softwareupdate -i -a'

# Misc
alias cat 'bat'
alias copy 'tr -d "\n" | pbcopy'
alias ct 'ctags -R --languages=ruby --exclude=.git --exclude=log . (bundle list --paths)'
alias htop 'sudo htop'
alias ygs 'yarn generate; and cd dist; and http-server -p 8080'
