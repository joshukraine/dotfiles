#!/usr/bin/env bash

set -e # Terminate script if anything exits with a non-zero value

################################################################################
# setup.sh
#
# This script uses GNU Stow to symlink files and directories into place.
# It can be run safely multiple times on the same machine. (idempotency)
#
# Usage: ./setup.sh [OPTIONS]
#
# Options:
#   --dry-run    Show what would be done without making any changes
#   --help       Show this help message
################################################################################

# Global variables
DRY_RUN=false
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_help() {
  cat << EOF
Usage: $0 [OPTIONS]

This script sets up dotfiles using GNU Stow for symlink management.
It can be run safely multiple times on the same machine.

Options:
  --dry-run    Show what would be done without making any changes
  --help       Show this help message

Examples:
  $0                # Normal setup
  $0 --dry-run      # Preview changes without applying them
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
  --dry-run)
    DRY_RUN=true
    shift
    ;;
  --help)
    show_help
    exit 0
    ;;
  *)
    echo "Unknown option: $1"
    show_help
    exit 1
    ;;
  esac
done

dotfiles_echo() {
  local fmt="$1"
  shift

  # shellcheck disable=SC2059
  printf "\\n[DOTFILES] ${fmt}\\n" "$@"
}

dotfiles_info() {
  local fmt="$1"
  shift

  # shellcheck disable=SC2059
  printf "[INFO] ${fmt}\\n" "$@"
}

dotfiles_warn() {
  local fmt="$1"
  shift

  # shellcheck disable=SC2059
  printf "[WARN] ${fmt}\\n" "$@" >&2
}

dotfiles_error() {
  local fmt="$1"
  shift

  # shellcheck disable=SC2059
  printf "[ERROR] ${fmt}\\n" "$@" >&2
}

run_command() {
  local cmd="$1"
  local description="$2"

  if [[ "$DRY_RUN" == "true" ]]; then
  dotfiles_info "[DRY RUN] Would run: %s" "$cmd"
  if [[ -n "$description" ]]; then
    dotfiles_info "  Purpose: %s" "$description"
  fi
  else
  dotfiles_info "Running: %s" "$cmd"
  if ! eval "$cmd"; then
    dotfiles_error "Failed to execute: %s" "$cmd"
    return 1
  fi
  fi
}

backup_stow_conflict() {
  dotfiles_warn "Conflict detected: ${1}"
  local BACKUP_SUFFIX
  BACKUP_SUFFIX="$(date +%Y-%m-%d)_$(date +%s)"
  local backup_path="${1}_${BACKUP_SUFFIX}"

  if [[ "$DRY_RUN" == "true" ]]; then
  dotfiles_info "[DRY RUN] Would backup %s to %s" "$1" "$backup_path"
  else
  dotfiles_info "Backing up %s to %s" "$1" "$backup_path"
  if ! mv -v "$1" "$backup_path"; then
    dotfiles_error "Failed to backup %s" "$1"
    return 1
  fi
  fi
}

# Main script starts here
main() {
  if [[ "$DRY_RUN" == "true" ]]; then
  dotfiles_echo "DRY RUN MODE - No changes will be made"
  fi

  dotfiles_echo "Initializing dotfiles setup..."

  # Check prerequisites
  check_prerequisites

  # Continue with existing setup logic but with improved error handling
  setup_hostname
  setup_directories
  handle_stow_conflicts
  setup_symlinks
  setup_shell_integration
  setup_tmux

  dotfiles_echo "Dotfiles setup complete!"
  show_next_steps
}

check_prerequisites() {
  local osname
  osname=$(uname)

  if [ "$osname" != "Darwin" ]; then
  dotfiles_error "This script only supports macOS. Current OS: %s" "$osname"
  exit 1
  fi

  if ! command -v stow >/dev/null; then
  dotfiles_error "GNU Stow is required but was not found. Try: brew install stow"
  exit 1
  fi

  dotfiles_info "Prerequisites check passed"

  if [[ "$DRY_RUN" == "false" ]]; then
  dotfiles_info "Requesting sudo access for hostname setup..."
  if ! sudo -v; then
    dotfiles_error "Failed to obtain sudo access"
    exit 1
  fi
  fi
}

setup_hostname() {
  dotfiles_echo "Setting HostName..."

  local computer_name local_host_name host_name
  computer_name=$(scutil --get ComputerName)
  local_host_name=$(scutil --get LocalHostName)

  if [[ "$DRY_RUN" == "true" ]]; then
  dotfiles_info "[DRY RUN] Would set HostName to: %s" "$local_host_name"
  dotfiles_info "[DRY RUN] Would update NetBIOSName in SMB server config"
  else
  run_command "sudo scutil --set HostName '$local_host_name'" "Set system hostname"
  host_name=$(scutil --get HostName)
  run_command "sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server.plist NetBIOSName -string '$host_name'" "Update SMB server NetBIOS name"
  fi

  printf "ComputerName:  ==> [%s]\\n" "$computer_name"
  printf "LocalHostName: ==> [%s]\\n" "$local_host_name"
  if [[ "$DRY_RUN" == "false" ]]; then
  printf "HostName:      ==> [%s]\\n" "$(scutil --get HostName)"
  fi
}

setup_directories() {
  if [ -z "$DOTFILES" ]; then
  export DOTFILES="${HOME}/dotfiles"
  fi

  dotfiles_info "Using DOTFILES directory: %s" "$DOTFILES"

  if [[ ! -d "$DOTFILES" ]]; then
  dotfiles_error "DOTFILES directory not found: %s" "$DOTFILES"
  exit 1
  fi

  if [ -z "$XDG_CONFIG_HOME" ]; then
  dotfiles_echo "Setting up ~/.config directory..."
  if [ ! -d "${HOME}/.config" ]; then
    if [[ "$DRY_RUN" == "true" ]]; then
      dotfiles_info "[DRY RUN] Would create directory: %s" "${HOME}/.config"
    else
      run_command "mkdir '${HOME}/.config'" "Create XDG config directory"
    fi
  fi
  export XDG_CONFIG_HOME="${HOME}/.config"
  fi

  if [ ! -d "${HOME}/.local/bin" ]; then
  dotfiles_echo "Setting up ~/.local/bin directory..."
  if [[ "$DRY_RUN" == "true" ]]; then
    dotfiles_info "[DRY RUN] Would create directory: %s" "${HOME}/.local/bin"
  else
    run_command "mkdir -pv '${HOME}/.local/bin'" "Create local bin directory"
  fi
  fi

  dotfiles_echo "Checking your system architecture..."

  local arch
  arch="$(uname -m)"

  if [ "$arch" == "arm64" ]; then
  dotfiles_info "Apple Silicon detected - setting HOMEBREW_PREFIX to /opt/homebrew"
  HOMEBREW_PREFIX="/opt/homebrew"
  else
  dotfiles_info "Intel Mac detected - setting HOMEBREW_PREFIX to /usr/local"
  HOMEBREW_PREFIX="/usr/local"
  fi
}

handle_stow_conflicts() {
  dotfiles_echo "Checking for potential stow conflicts..."

  if [[ "$DRY_RUN" == "false" ]]; then
  if ! cd "${DOTFILES}/"; then
    dotfiles_error "Failed to change to DOTFILES directory: %s" "$DOTFILES"
    exit 1
  fi
  else
  dotfiles_info "[DRY RUN] Would change to directory: %s" "$DOTFILES"
  fi

  local stow_conflicts=(
    ".asdfrc"
    ".bashrc"
    "CLAUDE.md"
    ".config/fish"
    ".config/ghostty"
    ".config/kitty"
    ".config/lazygit"
    ".config/nvim"
    ".config/starship.toml"
    ".config/tmux"
    ".config/yamllint"
    ".config/zsh"
    ".config/zsh-abbr"
    ".default-gems"
    ".default-npm-packages"
    ".gemrc"
    ".gitconfig"
    ".gitignore_global"
    ".gitmessage"
    ".hushlogin"
    ".irbrc"
    ".laptop.local"
    ".local/bin/colortest"
    ".local/bin/git-brst"
    ".local/bin/git-cm"
    ".local/bin/git-publish"
    ".local/bin/git-uncommit"
    ".local/bin/tat"
    ".npmrc"
    ".pryrc"
    ".ripgreprc"
    ".rubocop.yml"
    ".tool-versions"
    ".zshrc"
    "Brewfile"
  )

  local conflicts_found=0
  for item in "${stow_conflicts[@]}"; do
  if [ -e "${HOME}/${item}" ]; then
    # Potential conflict detected
    if [ -L "${HOME}/${item}" ]; then
      # This is a symlink and we can ignore it.
      dotfiles_info "Symlink already exists (OK): %s" "${HOME}/${item}"
      continue
    elif [ "$item" == ".tool-versions" ]; then
      # This was likely generated by Laptop, and we actually want to adopt it for now.
      dotfiles_info "Found %s - will adopt existing file" "${HOME}/.tool-versions"
      if [[ "$DRY_RUN" == "true" ]]; then
        dotfiles_info "[DRY RUN] Would run: stow --adopt asdf/"
      else
        run_command "stow --adopt asdf/" "Adopt existing .tool-versions file"
      fi
    else
      # This is a file or directory that will cause a conflict.
      conflicts_found=$((conflicts_found + 1))
      backup_stow_conflict "${HOME}/${item}"
    fi
  fi
  done

  if [[ $conflicts_found -gt 0 ]]; then
  dotfiles_info "Handled %d potential conflicts" "$conflicts_found"
  else
  dotfiles_info "No conflicts detected"
  fi
}

setup_symlinks() {
  dotfiles_echo "Setting up symlinks with GNU Stow..."

  if [[ "$DRY_RUN" == "false" ]] && [[ "$PWD" != "$DOTFILES" ]]; then
  if ! cd "${DOTFILES}/"; then
    dotfiles_error "Failed to change to DOTFILES directory: %s" "$DOTFILES"
    exit 1
  fi
  fi

  local stow_packages=0
  for item in *; do
  if [ -d "$item" ]; then
    stow_packages=$((stow_packages + 1))
    if [[ "$DRY_RUN" == "true" ]]; then
      dotfiles_info "[DRY RUN] Would stow package: %s" "$item"
    else
      run_command "stow '$item'/" "Stow package: $item"
    fi
  fi
  done

  dotfiles_info "Processed %d stow packages" "$stow_packages"
}

setup_shell_integration() {
  if command -v fish &>/dev/null; then
  dotfiles_echo "Initializing fish_user_paths..."
  local fish_cmd="set -U fish_user_paths $HOME/.asdf/shims $HOME/.local/bin $HOME/.bin $HOME/.yarn/bin $HOMEBREW_PREFIX/bin"
  if [[ "$DRY_RUN" == "true" ]]; then
    dotfiles_info "[DRY RUN] Would run: fish -c '%s'" "$fish_cmd"
  else
    run_command "command fish -c '$fish_cmd'" "Initialize Fish user paths"
  fi
  else
  dotfiles_info "Fish shell not found - skipping fish_user_paths setup"
  fi
}

setup_tmux() {
  if command -v tmux &>/dev/null; then
  if [ ! -d "${HOME}/.terminfo" ]; then
    dotfiles_echo "Installing custom terminfo entries..."
    if [[ "$DRY_RUN" == "true" ]]; then
      dotfiles_info "[DRY RUN] Would install terminfo entries for tmux and xterm"
    else
      # These entries enable, among other things, italic text in the terminal.
      run_command "tic -x '${DOTFILES}/terminfo/tmux-256color.terminfo'" "Install tmux terminfo entry"
      run_command "tic -x '${DOTFILES}/terminfo/xterm-256color-italic.terminfo'" "Install xterm italic terminfo entry"
    fi
  else
    dotfiles_info "Custom terminfo entries already installed"
  fi

  if [ ! -d "${DOTFILES}/tmux/.config/tmux/plugins" ]; then
    dotfiles_echo "Installing Tmux Plugin Manager..."
    if [[ "$DRY_RUN" == "true" ]]; then
      dotfiles_info "[DRY RUN] Would clone TPM to: %s" "${DOTFILES}/tmux/.config/tmux/plugins/tpm"
    else
      run_command "git clone https://github.com/tmux-plugins/tpm '${DOTFILES}/tmux/.config/tmux/plugins/tpm'" "Install Tmux Plugin Manager"
    fi
  else
    dotfiles_info "Tmux Plugin Manager already installed"
  fi
  else
  dotfiles_info "Tmux not found - skipping tmux setup"
  fi
}

show_next_steps() {
  echo
  echo "Possible next steps:"
  echo "-> Install Zap (https://www.zapzsh.com)"
  echo "-> Install Homebrew packages (brew bundle install)"
  if command -v tmux &>/dev/null; then
  echo "-> Install Tmux plugins with <prefix> + I (https://github.com/tmux-plugins/tpm)"
  fi
  echo "-> Set up 1Password CLI (https://developer.1password.com/docs/cli)"
  echo "-> Check out documentation for LazyVim (https://www.lazyvim.org/)"
  echo
}

# Error handling
trap 'dotfiles_error "Script failed at line $LINENO"' ERR

# Run main function
main "$@"
