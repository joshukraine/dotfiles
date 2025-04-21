function aua() {
  asdf update && asdf plugin-update --all
}

function bb() {
  if [ -e $HOME/Brewfile ]; then
    echo "-> Bundling Brewfile located at $HOME/Brewfile"
    sleep 2
    brew bundle --file $HOME/Brewfile
  else
    echo "Brewfile not found."
  fi
}

function bbc() {
  if [ -e $HOME/Brewfile ]; then
    echo "-> Running bundle cleanup dry-run for Brewfile located at $HOME/Brewfile"
    sleep 2
    brew bundle cleanup --file $HOME/Brewfile
  else
    echo "Brewfile not found."
  fi
}

function bbcf() {
  if [ -e $HOME/Brewfile ]; then
    echo "-> Running bundle cleanup (force) for Brewfile located at $HOME/Brewfile"
    sleep 2
    brew bundle cleanup --force --file $HOME/Brewfile
  else
    echo "Brewfile not found."
  fi
}

function bubo() {
  brew update && brew outdated
}

copy() {
    printf "%s" "$*" | tr -d "\n" | pbcopy
}

function ct() {
  ctags -R --languages=ruby --exclude=.git --exclude=log . $(bundle list --paths)
}

function copycwd() {
    echo "Choose how to display the home directory:"
    echo "1) ~"
    echo "2) \$HOME"
    echo "3) /Users/$(whoami)"
    read -r choice

    case $choice in
        1)
            pwd | sed "s|^$HOME|~|" | tr -d '\n' | pbcopy
            echo "Current path copied to clipboard with ~ as home directory."
            ;;
        2)
            pwd | sed "s|^$HOME|\\\$HOME|" | tr -d '\n' | pbcopy
            echo "Current path copied to clipboard with \$HOME as home directory."
            ;;
        3)
            pwd | tr -d '\n' | pbcopy
            echo "Current path copied to clipboard with full path as home directory."
            ;;
        *)
            echo "Invalid choice. Please enter 1, 2, or 3."
            ;;
    esac
}

function dsx() {
  find . -name "*.DS_Store" -type f -delete
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

function g() {
  if [[ $# -gt 0 ]]; then
    git "$@"
  else
    clear && git status --short --branch && echo
  fi
}

function gbrm() {
  git branch --merged master | grep -v "^\*\|  master" | xargs -n 1 git branch -d
}

function gl() {
  git log --date=format:"%b %d, %Y" --pretty=format:"%C(yellow bold)%h%Creset%C(white)%d%Creset %s%n%C(blue)%aN <%ae> | %cd%n"
}

function glg() {
  git log --graph --stat --date=format:"%b %d, %Y" --pretty=format:"%C(yellow bold)%h%Creset%C(white)%d%Creset %s%n%C(blue)%aN <%ae> | %cd%n"
}

function gwip() {
  git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify -m "--wip--"
}

function path() {
  echo $PATH | tr ":" "\n" | nl
}

function pi() {
  ping -Anc 5 1.1.1.1
}

function randpw() {
  openssl rand -base64 4 | md5 | head -c$1 ; echo
}

function rlv() {
  asdf list all ruby | rg '^\d'
}

# Thanks to https://github.com/Shpota/sha256
function sha256() {
    printf "%s %s\n" "$1" "$2" | sha256sum --check
}

# Create a new session named for current directory, or attach if exists.
function tna() {
  tmux new-session -As $(basename "$PWD" | tr . -)
}

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

# Kill all tmux sessions
function tka() {
  tmux ls | cut -d : -f 1 | xargs -I {} tmux kill-session -t {}
}

function ygs() {
  yarn generate && http-server dist/ -p 8080
}

# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/rails/rails.plugin.zsh
function _rails_command () {
  if [ -e "bin/rails" ]; then
    bin/rails $@
  else
    command rails $@
  fi
}

# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/rails/rails.plugin.zsh
function _rake_command () {
  if [ -e "bin/rake" ]; then
    bin/rake $@
  elif type bundle &> /dev/null && [ -e "Gemfile" ]; then
    bundle exec rake $@
  else
    command rake $@
  fi
}

function _rspec_command () {
  if [ -e "bin/rspec" ]; then
    bin/rspec $@
  elif type bundle &> /dev/null && [ -e "Gemfile" ]; then
    bundle exec rspec $@
  else
    command rspec $@
  fi
}

function _spring_command () {
  if [ -e "bin/spring" ]; then
    bin/spring $@
  elif type bundle &> /dev/null && [ -e "Gemfile" ]; then
    bundle exec spring $@
  else
    command spring $@
  fi
}

function _mina_command () {
  if [ -e "bin/mina" ]; then
    bin/mina $@
  elif type bundle &> /dev/null && [ -e "Gemfile" ]; then
    bundle exec mina $@
  else
    command mina $@
  fi
}

function n_test_runs() {
  for (( n=0; n<$1; n++ ));
  do { time bundle exec rspec ./spec; } 2>> time.txt;
  done
}

# https://yazi-rs.github.io/docs/quick-start#shell-wrapper
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

function update_jumpstart() {
    git fetch jumpstart-pro
    git merge jumpstart-pro/main
}
