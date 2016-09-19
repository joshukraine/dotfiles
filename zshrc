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

# Prompt {{{
source $HOME/dotfiles/zsh/prompt
# }}}

# Tmux {{{
source $HOME/dotfiles/zsh/tmux
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
