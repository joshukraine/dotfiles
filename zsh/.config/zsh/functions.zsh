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


function gcom() {
  local do_pull=0

  # Help message
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  printf "%s\n" "Usage: gcom [OPTION]
Switch to the default Git branch (e.g., main or master), with optional pull.

Options:
  -p          Pull latest changes after switching to the default branch
  -h, --help  Show this help message

Examples:
  gcom        # Checkout default branch only
  gcom -p     # Checkout default branch and pull latest changes"
  return 0
  fi

  # Pull flag
  if [[ "$1" == "-p" ]]; then
    do_pull=1
  fi

  # Check if we're in a Git repo
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Not a git repository."
    return 1
  fi

  # Check for uncommitted changes
  if ! git-check-uncommitted --prompt; then
    return 1
  fi

  # Check if remote exists before fetching
  if git remote | grep -q "^origin$"; then
    echo "Fetching latest from origin..."
    git fetch origin > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
      echo "Failed to fetch from origin."
      return 1
    fi
  fi

  # Determine default branch
  local default_branch=""

  # Try to get default branch from remote if it exists
  if git remote | grep -q "^origin$"; then
    default_branch=$(git remote show origin 2>/dev/null | awk '/HEAD branch/ { print $NF }')
  fi

  if [[ -z "$default_branch" ]]; then
    if git show-ref --quiet refs/heads/main; then
      default_branch="main"
    elif git show-ref --quiet refs/heads/master; then
      default_branch="master"
    else
      echo "Could not determine default branch."
      return 1
    fi
  fi

  echo "Switching to $default_branch"
  git checkout "$default_branch"
  if [[ $? -ne 0 ]]; then
    echo "Failed to checkout $default_branch"
    return 1
  fi

  if [[ $do_pull -eq 1 ]]; then
    echo "Pulling latest changes..."
    git pull
    if [[ $? -ne 0 ]]; then
      echo "Failed to pull changes."
      return 1
    fi
  fi
}

function path() {
  echo $PATH | tr ":" "\n" | nl
}

function pi() {
  ping -Anc 5 1.1.1.1
}

function rlv() {
  asdf list all ruby | rg '^\d'
}

# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/rails/rails.plugin.zsh
# function _rails_command () {
#   if [ -e "bin/rails" ]; then
#     bin/rails $@
#   else
#     command rails $@
#   fi
# }

# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/rails/rails.plugin.zsh
# function _rake_command () {
#   if [ -e "bin/rake" ]; then
#     bin/rake $@
#   elif type bundle &> /dev/null && [ -e "Gemfile" ]; then
#     bundle exec rake $@
#   else
#     command rake $@
#   fi
# }

# function _rspec_command () {
#   if [ -e "bin/rspec" ]; then
#     bin/rspec $@
#   elif type bundle &> /dev/null && [ -e "Gemfile" ]; then
#     bundle exec rspec $@
#   else
#     command rspec $@
#   fi
# }

# function _spring_command () {
#   if [ -e "bin/spring" ]; then
#     bin/spring $@
#   elif type bundle &> /dev/null && [ -e "Gemfile" ]; then
#     bundle exec spring $@
#   else
#     command spring $@
#   fi
# }

# function _mina_command () {
#   if [ -e "bin/mina" ]; then
#     bin/mina $@
#   elif type bundle &> /dev/null && [ -e "Gemfile" ]; then
#     bundle exec mina $@
#   else
#     command mina $@
#   fi
# }

# function n_test_runs() {
#   for (( n=0; n<$1; n++ ));
#   do { time bundle exec rspec ./spec; } 2>> time.txt;
#   done
# }

# Push current branch to origin with upstream tracking (smart default branch detection)
function gpum() {
  # Help message
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  printf "%s\n" "Usage: gpum [OPTION]
Push current branch to origin with upstream tracking to the default branch.
Intelligently detects whether to use 'main' or 'master' as the default branch.

Options:
  -h, --help  Show this help message

Examples:
  gpum        # Push current branch to origin with upstream tracking"
  return 0
  fi

  # Check if we're in a Git repo
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Not a git repository."
    return 1
  fi

  # Get current branch
  local current_branch=$(git branch --show-current)
  if [[ -z "$current_branch" ]]; then
    echo "Could not determine current branch."
    return 1
  fi

  # Check if remote exists
  if ! git remote | grep -q "^origin$"; then
    echo "No 'origin' remote found."
    return 1
  fi

  # Determine default branch
  local default_branch=""

  # Try to get default branch from remote
  default_branch=$(git remote show origin 2>/dev/null | awk '/HEAD branch/ { print $NF }')

  # Fallback if needed
  if [[ -z "$default_branch" ]]; then
    if git show-ref --quiet refs/heads/main; then
      default_branch="main"
    elif git show-ref --quiet refs/heads/master; then
      default_branch="master"
    else
      echo "Could not determine default branch."
      return 1
    fi
  fi

  echo "Pushing $current_branch to origin with upstream tracking..."
  git push -u origin "$current_branch"
  if [[ $? -ne 0 ]]; then
    echo "Failed to push to origin."
    return 1
  fi

  echo "Successfully pushed $current_branch to origin (default branch: $default_branch)"
}

# Rebase current branch against default branch (smart branch detection)
function grbm() {
  # Help message
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  printf "%s\n" "Usage: grbm [OPTION]
Rebase current branch against the default branch (main or master).
Intelligently detects the default branch and fetches latest changes.

Options:
  -h, --help  Show this help message

Examples:
  grbm        # Rebase current branch against default branch"
  return 0
  fi

  # Check if we're in a Git repo
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Not a git repository."
    return 1
  fi

  # Get current branch
  local current_branch=$(git branch --show-current)
  if [[ -z "$current_branch" ]]; then
    echo "Could not determine current branch."
    return 1
  fi

  # Check for uncommitted changes
  if ! git-check-uncommitted --prompt; then
    return 1
  fi

  # Check if remote exists and fetch
  if git remote | grep -q "^origin$"; then
    echo "Fetching latest from origin..."
    git fetch origin > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
      echo "Failed to fetch from origin."
      return 1
    fi
  fi

  # Determine default branch
  local default_branch=""

  # Try to get default branch from remote
  if git remote | grep -q "^origin$"; then
    default_branch=$(git remote show origin 2>/dev/null | awk '/HEAD branch/ { print $NF }')
  fi

  # Fallback if needed
  if [[ -z "$default_branch" ]]; then
    if git show-ref --quiet refs/heads/main; then
      default_branch="main"
    elif git show-ref --quiet refs/heads/master; then
      default_branch="master"
    else
      echo "Could not determine default branch."
      return 1
    fi
  fi

  # Don't rebase if we're already on the default branch
  if [[ "$current_branch" == "$default_branch" ]]; then
    echo "Already on default branch ($default_branch). Nothing to rebase."
    return 0
  fi

  echo "Rebasing $current_branch against $default_branch..."
  git rebase "origin/$default_branch"
  if [[ $? -ne 0 ]]; then
    echo "Rebase failed. You may need to resolve conflicts manually."
    return 1
  fi

  echo "Successfully rebased $current_branch against $default_branch"
}

# Regenerate abbreviations for all shells from shared YAML source
function reload-abbr() {
  # Help message
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    printf "%s\n" "Usage: reload-abbr [OPTION]
Regenerate abbreviations for all shells from shared YAML source.
This command can be run from any directory.

Options:
  -h, --help  Show this help message

Examples:
  reload-abbr  # Regenerate all abbreviations from shared/abbreviations.yaml"
    return 0
  fi

  # Find the dotfiles directory
  local dotfiles_dir="$HOME/dotfiles"
  if [[ ! -d "$dotfiles_dir" ]]; then
    echo "❌ Error: Dotfiles directory not found at $dotfiles_dir"
    return 1
  fi

  # Check if the generation script exists
  local generate_script="$dotfiles_dir/shared/generate-all-abbr.sh"
  if [[ ! -f "$generate_script" ]]; then
    echo "❌ Error: Generation script not found at $generate_script"
    return 1
  fi

  # Check if script is executable
  if [[ ! -x "$generate_script" ]]; then
    echo "❌ Error: Generation script is not executable: $generate_script"
    echo "Run: chmod +x $generate_script"
    return 1
  fi

  # Run the generation script
  echo "🔄 Regenerating abbreviations from any directory..."
  "$generate_script"
  local exit_code=$?

  if [[ $exit_code -eq 0 ]]; then
    echo
    echo "💡 Don't forget to reload your shell to use the new abbreviations:"
    echo "   Fish: exec fish"
    echo "   Zsh:  src"
  fi

  return $exit_code
}
