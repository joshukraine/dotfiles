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

setopt auto_cd
cdpath=($HOME/dev $HOME/dev/projects $HOME/Sites $HOME/dev/vm $HOME)

# if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

source $(brew --prefix nvm)/nvm.sh


export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh --no-rehash)"
