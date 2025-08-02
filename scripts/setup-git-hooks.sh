#!/bin/bash
#
# Git Hooks Setup Script
#
# Sets up git hooks for automated configuration validation and workflow enhancement:
# - Pre-commit hooks for linting and validation (via pre-commit framework)
# - Pre-push hooks for additional checks
# - Post-commit hook to detect dirty working tree after commits
#
# Usage:
#   ./scripts/setup-git-hooks.sh [options]
#
# Options:
#   --help           Show this help message
#   --uninstall      Remove git hooks
#   --check          Check if hooks are installed
#   --update         Update existing hooks

set -euo pipefail

# Script directory and dotfiles root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Color codes for output
if [[ -t 1 ]] && [[ "${CI:-}" != "true" ]]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  BLUE='\033[0;34m'
  NC='\033[0m' # No Color
else
  RED=''
  GREEN=''
  YELLOW=''
  BLUE=''
  NC=''
fi

# Logging functions
log_info() {
  echo -e "${BLUE}ℹ${NC} $1" >&2
}

log_success() {
  echo -e "${GREEN}✓${NC} $1" >&2
}

log_warning() {
  echo -e "${YELLOW}⚠${NC} $1" >&2
}

log_error() {
  echo -e "${RED}✗${NC} $1" >&2
}

# Show usage information
show_usage() {
  cat <<EOF
Git Hooks Setup Script

Sets up git hooks for automated configuration validation and workflow enhancement:
- Pre-commit and pre-push hooks (via pre-commit framework)
- Post-commit hook to detect dirty working tree after commits

USAGE:
    ./scripts/setup-git-hooks.sh [OPTIONS]

OPTIONS:
    -h, --help       Show this help message
    -u, --uninstall  Remove git hooks
    -c, --check      Check if hooks are installed
    --update         Update existing hooks

EXAMPLES:
    ./scripts/setup-git-hooks.sh         # Install hooks
    ./scripts/setup-git-hooks.sh --check # Check installation status
    ./scripts/setup-git-hooks.sh -u      # Uninstall hooks
EOF
}

# Check if we're in a git repository
check_git_repo() {
  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    log_error "Not in a git repository"
    exit 1
  fi
}

# Check if pre-commit is installed
check_prerecommit() {
  if ! command -v pre-commit >/dev/null 2>&1; then
    log_warning "pre-commit not found. Installing via pip..."

    # Try to install pre-commit
    if command -v pip3 >/dev/null 2>&1; then
      pip3 install pre-commit
    elif command -v pip >/dev/null 2>&1; then
      pip install pre-commit
    else
      log_error "Cannot install pre-commit: pip not found"
      log_error "Install manually: pip install pre-commit"
      return 1
    fi
  fi

  log_success "pre-commit is available"
  return 0
}

# Install post-commit hook for dirty working tree detection
install_postcommit_hook() {
  local git_hooks_dir
  git_hooks_dir="$(git rev-parse --git-dir)/hooks"
  local hook_file="${git_hooks_dir}/post-commit"

  log_info "Installing post-commit hook..."

  # Create post-commit hook
  cat > "${hook_file}" << 'EOF'
#!/bin/bash
#
# Post-commit hook to detect when pre-commit hooks have left the working tree dirty
#
# This happens when pre-commit hooks (like trailing-whitespace, end-of-file-fixer)
# automatically modify files after they've been staged but before the commit is created.

set -euo pipefail

# Colors for output
if [[ -t 1 ]]; then
  YELLOW='\033[1;33m'
  RED='\033[0;31m'
  BLUE='\033[0;34m'
  NC='\033[0m' # No Color
else
  YELLOW=''
  RED=''
  BLUE=''
  NC=''
fi

# Check if working tree is dirty (has unstaged changes)
if ! git diff-index --quiet HEAD --; then
  echo
  echo -e "${YELLOW}⚠️  WARNING: Working tree is dirty after commit${NC}" >&2
  echo -e "${BLUE}ℹ️  This usually happens when pre-commit hooks auto-fix files after staging.${NC}" >&2
  echo
  echo -e "${RED}Unstaged changes detected:${NC}" >&2
  git diff --name-only HEAD
  echo
  echo -e "${BLUE}💡 To fix this, run one of:${NC}" >&2
  echo -e "   ${BLUE}git add . && git commit --amend --no-edit${NC}  # Include fixes in last commit" >&2
  echo -e "   ${BLUE}git add . && git commit -m \"style: auto-fix by pre-commit hooks\"${NC}  # Separate commit" >&2
  echo
fi
EOF

  # Make executable
  chmod +x "${hook_file}"
  log_success "Post-commit hook installed"
}

# Install git hooks
install_hooks() {
  log_info "Installing git hooks..."

  # Change to dotfiles root
  cd "${DOTFILES_ROOT}"

  # Check prerequisites
  if ! check_prerecommit; then
    return 1
  fi

  # Install pre-commit hooks
  if pre-commit install --hook-type pre-commit --hook-type pre-push; then
    log_success "Pre-commit framework hooks installed"

    # Install custom post-commit hook
    install_postcommit_hook

    # Show hook status
    log_info "Installed hooks:"
    pre-commit --version

    # Test hooks
    log_info "Testing hooks installation..."
    if pre-commit run --all-files --show-diff-on-failure; then
      log_success "All validation hooks passed"
    else
      log_warning "Some validation hooks failed - this is normal for first run"
      log_info "Run './scripts/validate-config.sh --fix' to auto-fix common issues"
    fi

  else
    log_error "Failed to install git hooks"
    return 1
  fi
}

# Uninstall git hooks
uninstall_hooks() {
  log_info "Uninstalling git hooks..."

  cd "${DOTFILES_ROOT}"

  if command -v pre-commit >/dev/null 2>&1; then
    pre-commit uninstall --hook-type pre-commit --hook-type pre-push
    log_success "Pre-commit framework hooks uninstalled"
  else
    log_warning "pre-commit not found, removing hooks manually..."

    # Remove hooks manually
    git_hooks_dir="$(git rev-parse --git-dir)/hooks"
    for hook in pre-commit pre-push; do
      if [[ -f "${git_hooks_dir}/${hook}" ]]; then
        rm "${git_hooks_dir}/${hook}"
        log_success "Removed ${hook} hook"
      fi
    done
  fi

  # Remove custom post-commit hook
  git_hooks_dir="$(git rev-parse --git-dir)/hooks"
  if [[ -f "${git_hooks_dir}/post-commit" ]]; then
    rm "${git_hooks_dir}/post-commit"
    log_success "Removed post-commit hook"
  fi
}

# Check hook installation status
check_hooks() {
  log_info "Checking git hooks installation..."

  cd "${DOTFILES_ROOT}"

  git_hooks_dir="$(git rev-parse --git-dir)/hooks"

  # Check for pre-commit hook
  if [[ -f "${git_hooks_dir}/pre-commit" ]]; then
    log_success "pre-commit hook is installed"
  else
    log_warning "pre-commit hook is NOT installed"
  fi

  # Check for pre-push hook
  if [[ -f "${git_hooks_dir}/pre-push" ]]; then
    log_success "pre-push hook is installed"
  else
    log_warning "pre-push hook is NOT installed"
  fi

  # Check for post-commit hook
  if [[ -f "${git_hooks_dir}/post-commit" ]]; then
    log_success "post-commit hook is installed"
  else
    log_warning "post-commit hook is NOT installed"
  fi

  # Check pre-commit status
  if command -v pre-commit >/dev/null 2>&1; then
    echo
    log_info "Pre-commit configuration:"
    pre-commit --version

    if [[ -f ".pre-commit-config.yaml" ]]; then
      log_success "Pre-commit config file exists"
    else
      log_warning "Pre-commit config file missing"
    fi
  else
    log_warning "pre-commit tool not installed"
  fi
}

# Update existing hooks
update_hooks() {
  log_info "Updating git hooks..."

  cd "${DOTFILES_ROOT}"

  if command -v pre-commit >/dev/null 2>&1; then
    # Update hook repositories
    pre-commit autoupdate

    # Reinstall with latest versions
    pre-commit install --hook-type pre-commit --hook-type pre-push --overwrite

    log_success "Git hooks updated successfully"
  else
    log_error "pre-commit not found - cannot update hooks"
    return 1
  fi
}

# Main function
main() {
  local action="install"

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      -h | --help)
        show_usage
        exit 0
        ;;
      -u | --uninstall)
        action="uninstall"
        shift
        ;;
      -c | --check)
        action="check"
        shift
        ;;
      --update)
        action="update"
        shift
        ;;
      *)
        log_error "Unknown option: $1"
        show_usage >&2
        exit 1
        ;;
    esac
  done

  # Verify git repository
  check_git_repo

  # Execute action
  case ${action} in
    install)
      install_hooks
      ;;
    uninstall)
      uninstall_hooks
      ;;
    check)
      check_hooks
      ;;
    update)
      update_hooks
      ;;
    *)
      log_error "Unknown action: ${action}"
      exit 1
      ;;
  esac
}

# Run main function
main "$@"
