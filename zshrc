# ~/.zshrc

export PATH=$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/go/bin
export EDITOR="vim"
export BUNDLER_EDITOR=$EDITOR
export MANPAGER="less -X" # Don’t clear the screen after quitting a manual page
export TERM="screen-256color"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export SOURCE_ANNOTATION_DIRECTORIES="spec"
export DISABLE_AUTO_TITLE=true
export _Z_OWNER=$USER
export RUBY_CONFIGURE_OPTIONS='--with-opt-dir=/usr/local/opt/openssl:/usr/local/opt/readline:/usr/local/opt/libyaml:/usr/local/opt/gdbm'

setopt auto_cd
cdpath=($HOME/code $HOME/dotfiles $HOME/Developer $HOME/Sites $HOME/Dropbox $HOME)

HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history
HIST_STAMPS="yyyy-mm-dd"

. $HOME/dotfiles/zsh/oh-my-zsh
. $HOME/dotfiles/zsh/aliases
. $HOME/dotfiles/zsh/prompt
. $HOME/dotfiles/zsh/tmux
. $HOME/dotfiles/zsh/functions
. $HOME/dotfiles/zsh/z.sh

# asdf
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# Travis CI
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

# Include local settings
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
