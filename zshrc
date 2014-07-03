export ZSH=$HOME/.oh-my-zsh
export UPDATE_ZSH_DAYS=7

ZSH_THEME="joshukraine"
ZSH_CUSTOM=$HOME/.dotfiles/oh-my-zsh/custom
COMPLETION_WAITING_DOTS="true"

plugins=(git git-flow pow vagrant)

source $ZSH/oh-my-zsh.sh
source $ZSH_CUSTOM/aliases

HISTSIZE=20000
HISTFILE=~/.zsh_history
SAVEHIST=20000

export BUNDLER_EDITOR="vim"
export EDITOR="vim"

export PATH=/Users/joshukraine/bin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/X11/bin:/usr/bin:/usr/sbin:/bin:/sbin:/usr/bin
export PATH="$PATH:/usr/local/lib/node_modules"
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="$HOME/.bin:$PATH"

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

source $(brew --prefix nvm)/nvm.sh

