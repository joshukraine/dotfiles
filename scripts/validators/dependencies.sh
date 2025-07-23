#!/bin/bash
#
# Dependencies Validator
#
# Validates that required tools and dependencies are available:
# - Essential development tools (git, shells, editor)
# - Validator framework dependencies (yq, shellcheck, bats)
# - Core dotfiles functionality tools (stow, tmux, homebrew)
# - Brewfile packages availability check
# - Version compatibility verification
#
# Exit codes:
#   0 - All dependency validation passed
#   1 - Missing dependencies found
#   2 - Validator error

set -euo pipefail

# Inherit configuration from main validator
DOTFILES_ROOT="${DOTFILES_ROOT:-$(pwd)}"
FIX_MODE="${FIX_MODE:-0}"
REPORT_MODE="${REPORT_MODE:-0}"
CI_MODE="${CI_MODE:-0}"
VERBOSE="${VERBOSE:-1}"

# Validation state
VALIDATION_ERRORS=0
WARNINGS=0
MISSING_CRITICAL=0
MISSING_OPTIONAL=0

# File paths
BREWFILE="${DOTFILES_ROOT}/brew/Brewfile"

# Logging functions
log_info() {
  if [[ ${VERBOSE} -eq 1 && ${CI_MODE} -eq 0 ]]; then
    echo "  ℹ $1" >&2
  fi
}

log_success() {
  if [[ ${CI_MODE} -eq 0 ]]; then
    echo "  ✓ $1" >&2
  else
    echo "DEPENDENCIES_SUCCESS: $1" >&2
  fi
}

log_warning() {
  if [[ ${CI_MODE} -eq 0 ]]; then
    echo "  ⚠ $1" >&2
  else
    echo "DEPENDENCIES_WARNING: $1" >&2
  fi
  ((WARNINGS++))
}

log_error() {
  if [[ ${CI_MODE} -eq 0 ]]; then
    echo "  ✗ $1" >&2
  else
    echo "DEPENDENCIES_ERROR: $1" >&2
  fi
  ((VALIDATION_ERRORS++))
}

# Check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Get version of a command (if available)
get_version() {
  local cmd="$1"
  local version_flag="${2:---version}"

  if command_exists "${cmd}"; then
    "${cmd}" "${version_flag}" 2>/dev/null | head -1 || echo "unknown"
  else
    echo "not installed"
  fi
}

# Validate essential development tools
validate_essential_tools() {
  log_info "Checking essential development tools..."

  # Critical tools that must be present
  local essential_tools=(
    "git:Git version control system"
    "fish:Fish shell"
    "zsh:Zsh shell"
    "nvim:Neovim editor"
    "tmux:Terminal multiplexer"
  )

  # Only require Homebrew on macOS
  if [[ "$(uname -s)" == "Darwin" ]]; then
    essential_tools+=("brew:Homebrew package manager")
  fi

  local missing_essential=()

  for tool_desc in "${essential_tools[@]}"; do
    local tool="${tool_desc%%:*}"
    local description="${tool_desc#*:}"

    if command_exists "${tool}"; then
      local version
      version=$(get_version "${tool}")
      log_success "${description} available: ${version}"
    else
      missing_essential+=("${tool}")
      log_error "${description} missing: ${tool}"
      ((MISSING_CRITICAL++))
    fi
  done

  if [[ ${#missing_essential[@]} -gt 0 ]]; then
    log_error "Missing essential tools: ${missing_essential[*]}"
    if [[ "$(uname -s)" == "Darwin" ]]; then
      log_error "Install with: brew install ${missing_essential[*]}"
    else
      log_error "Install with your package manager (e.g., apt install ${missing_essential[*]})"
    fi
    return 1
  fi

  log_success "All essential development tools available"
  return 0
}

# Validate validator framework dependencies
validate_validator_dependencies() {
  log_info "Checking validator framework dependencies..."

  # Tools required by validators
  local validator_tools=(
    "yq:YAML processor (for abbreviations validator)"
    "shellcheck:Shell script linter (for shell-syntax validator)"
    "bats:Shell testing framework (for future testing)"
    "stow:Symlink manager (for symlinks validator)"
  )

  local missing_validator=()

  for tool_desc in "${validator_tools[@]}"; do
    local tool="${tool_desc%%:*}"
    local description="${tool_desc#*:}"

    if command_exists "${tool}"; then
      local version
      version=$(get_version "${tool}")
      log_success "${description} available: ${version}"
    else
      missing_validator+=("${tool}")
      log_error "${description} missing: ${tool}"
      ((MISSING_CRITICAL++))
    fi
  done

  if [[ ${#missing_validator[@]} -gt 0 ]]; then
    log_error "Missing validator dependencies: ${missing_validator[*]}"
    if [[ "$(uname -s)" == "Darwin" ]]; then
      log_error "Install with: brew install ${missing_validator[*]}"
    else
      log_error "Install with your package manager (e.g., apt install ${missing_validator[*]})"
    fi

    if [[ ${FIX_MODE} -eq 1 ]]; then
      log_info "Fixing: Installing missing validator dependencies..."
      if [[ "$(uname -s)" == "Darwin" ]] && command_exists brew; then
        if brew install "${missing_validator[@]}" >/dev/null 2>&1; then
          log_success "Fixed: Installed ${missing_validator[*]}"
        else
          log_error "Failed to install missing dependencies"
          return 1
        fi
      else
        log_warning "Auto-fix not available on this platform"
        return 1
      fi
    else
      return 1
    fi
  fi

  log_success "All validator dependencies available"
  return 0
}

# Validate core dotfiles functionality tools
validate_dotfiles_tools() {
  log_info "Checking dotfiles functionality tools..."

  # Tools that enhance dotfiles functionality
  local dotfiles_tools=(
    "rg:ripgrep (for FZF and search)"
    "fd:fd-find (for FZF and navigation)"
    "eza:Modern ls replacement"
    "bat:Better cat with syntax highlighting"
    "fzf:Fuzzy finder"
  )

  local missing_tools=0

  for tool_desc in "${dotfiles_tools[@]}"; do
    local tool="${tool_desc%%:*}"
    local description="${tool_desc#*:}"

    if command_exists "${tool}"; then
      local version
      version=$(get_version "${tool}")
      log_success "${description} available: ${version}"
    else
      log_warning "${description} missing: ${tool}"
      ((missing_tools++))
      ((MISSING_OPTIONAL++))
    fi
  done

  if [[ ${missing_tools} -gt 0 ]]; then
    log_warning "${missing_tools} optional dotfiles tools missing"
    log_info "Install missing tools with: brew bundle install"
  else
    log_success "All dotfiles tools available"
  fi

  return 0
}

# Validate Homebrew and Brewfile
validate_homebrew_setup() {
  # Skip Homebrew validation on non-macOS systems
  if [[ "$(uname -s)" != "Darwin" ]]; then
    log_info "Skipping Homebrew validation on non-macOS system"
    return 0
  fi

  log_info "Checking Homebrew setup..."

  if ! command_exists "brew"; then
    log_error "Homebrew not installed - required for package management"
    return 1
  fi

  # Check Brewfile exists
  if [[ ! -f "${BREWFILE}" ]]; then
    log_error "Brewfile not found: brew/Brewfile"
    return 1
  fi

  log_success "Brewfile found: brew/Brewfile"

  # Count packages in Brewfile
  local total_packages
  total_packages=$(grep -c "^brew\|^cask" "${BREWFILE}" 2>/dev/null || echo "0")

  if [[ ${total_packages} -eq 0 ]]; then
    log_warning "No packages defined in Brewfile"
  else
    log_info "Brewfile contains ${total_packages} packages"
  fi

  # Check if brew bundle is available
  if ! brew bundle --help >/dev/null 2>&1; then
    log_error "brew bundle not available - install with: brew tap homebrew/bundle"
    return 1
  fi

  log_success "Homebrew bundle available"

  # Quick check if Brewfile is valid
  if ! brew bundle check --file="${BREWFILE}" >/dev/null 2>&1; then
    log_warning "Some packages in Brewfile are not installed"
    log_info "Run 'brew bundle install' to install missing packages"
  else
    log_success "All Brewfile packages are installed"
  fi

  return 0
}

# Validate shell availability and versions
validate_shell_compatibility() {
  log_info "Checking shell compatibility..."

  # Check Fish version (minimum 3.0 recommended)
  if command_exists "fish"; then
    local fish_version
    fish_version=$(get_version "fish")
    local fish_major
    fish_major=$(echo "${fish_version}" | grep -o "fish, version [0-9]*" | grep -o "[0-9]*" || echo "0")

    if [[ ${fish_major} -ge 3 ]]; then
      log_success "Fish version compatible: ${fish_version}"
    else
      log_warning "Fish version may be too old: ${fish_version} (recommend 3.0+)"
    fi
  fi

  # Check Zsh version (minimum 5.0 recommended)
  if command_exists "zsh"; then
    local zsh_version
    zsh_version=$(get_version "zsh")
    local zsh_major
    zsh_major=$(echo "${zsh_version}" | grep -o "zsh [0-9]*\.[0-9]*" | cut -d' ' -f2 | cut -d'.' -f1 || echo "0")

    if [[ ${zsh_major} -ge 5 ]]; then
      log_success "Zsh version compatible: ${zsh_version}"
    else
      log_warning "Zsh version may be too old: ${zsh_version} (recommend 5.0+)"
    fi
  fi

  # Check if shells are available in /etc/shells
  local shells_file="/etc/shells"
  if [[ -f "${shells_file}" ]]; then
    local fish_path zsh_path
    fish_path=$(command -v fish 2>/dev/null || echo "")
    zsh_path=$(command -v zsh 2>/dev/null || echo "")

    if [[ -n "${fish_path}" ]]; then
      if grep -q "${fish_path}" "${shells_file}" 2>/dev/null; then
        log_success "Fish is registered in /etc/shells"
      else
        log_warning "Fish not found in /etc/shells - add with:"
        log_info "  sudo sh -c 'echo ${fish_path} >> /etc/shells'"
      fi
    fi

    if [[ -n "${zsh_path}" ]]; then
      if grep -q "${zsh_path}" "${shells_file}" 2>/dev/null; then
        log_success "Zsh is registered in /etc/shells"
      else
        log_warning "Zsh not found in /etc/shells - add with:"
        log_info "  sudo sh -c 'echo ${zsh_path} >> /etc/shells'"
      fi
    fi
  fi

  return 0
}

# Check system compatibility
validate_system_compatibility() {
  log_info "Checking system compatibility..."

  # Check platform
  local platform
  platform=$(uname -s)

  case "${platform}" in
    Darwin)
      log_success "Running on macOS (supported platform)"

      # Check macOS version
      local macos_version
      macos_version=$(sw_vers -productVersion 2>/dev/null || echo "unknown")
      log_info "macOS version: ${macos_version}"
      ;;
    Linux)
      log_warning "Running on Linux (limited support)"
      ;;
    *)
      log_warning "Running on unsupported platform: ${platform}"
      ;;
  esac

  # Check architecture (for Homebrew compatibility)
  local arch
  arch=$(uname -m)
  case "${arch}" in
    arm64|x86_64)
      log_success "Architecture supported: ${arch}"
      ;;
    *)
      log_warning "Architecture may not be fully supported: ${arch}"
      ;;
  esac

  return 0
}

# Main validation function
main() {
  local validation_failed=0

  # Change to dotfiles root
  cd "${DOTFILES_ROOT}"

  # Run all dependency validations
  if ! validate_essential_tools; then
    validation_failed=1
  fi

  if ! validate_validator_dependencies; then
    validation_failed=1
  fi

  if ! validate_dotfiles_tools; then
    # Don't fail on missing optional tools
    :
  fi

  if ! validate_homebrew_setup; then
    validation_failed=1
  fi

  if ! validate_shell_compatibility; then
    # Don't fail on version warnings
    :
  fi

  if ! validate_system_compatibility; then
    # Don't fail on platform warnings
    :
  fi

  # Summary
  if [[ ${validation_failed} -eq 1 ]]; then
    log_error "Dependencies validation failed with ${VALIDATION_ERRORS} error(s)"
    if [[ ${MISSING_CRITICAL} -gt 0 ]]; then
      log_error "Critical dependencies missing: ${MISSING_CRITICAL}"
    fi
    if [[ ${MISSING_OPTIONAL} -gt 0 ]]; then
      log_warning "Optional tools missing: ${MISSING_OPTIONAL}"
    fi
    if [[ ${WARNINGS} -gt 0 ]]; then
      log_warning "Total warnings: ${WARNINGS}"
    fi
    return 1
  else
    log_success "Dependencies validation passed"
    if [[ ${MISSING_CRITICAL} -eq 0 && ${MISSING_OPTIONAL} -eq 0 ]]; then
      log_success "All tools available"
    elif [[ ${MISSING_OPTIONAL} -gt 0 ]]; then
      log_success "All critical tools available, ${MISSING_OPTIONAL} optional tools missing"
    fi
    if [[ ${WARNINGS} -gt 0 ]]; then
      log_warning "Total warnings: ${WARNINGS}"
    fi
    return 0
  fi
}

# Run main function
main
