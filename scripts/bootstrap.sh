#!/usr/bin/env bash

set -e

################################################################################
# bootstrap.sh
#
# Single bootstrap script to set up a fresh Mac from zero. Installs
# prerequisites, clones the dotfiles repo, runs setup.sh, installs language
# runtimes, and configures the default shell.
#
# Usage:
#   bash <(curl -fsSL https://raw.githubusercontent.com/pyeh/dotfiles/master/scripts/bootstrap.sh)
#
# Or after cloning:
#   ./scripts/bootstrap.sh [OPTIONS]
#
# Options:
#   --dry-run            Show what would be done without making changes
#   --skip-brew-bundle   Skip the full Brewfile install (Phase 9)
#   --help               Show this help message
################################################################################

# ---------------------------------------------------------------------------
# Phase 0: Preflight
# ---------------------------------------------------------------------------

DOTFILES_REPO="https://github.com/pyeh/dotfiles.git"
DOTFILES_DIR="${HOME}/dotfiles"
DOTFILES_BRANCH="master"

DRY_RUN=false
SKIP_BREW_BUNDLE=false

# Logging helpers (mirrors setup.sh patterns)
bootstrap_echo() {
  local fmt="$1"
  shift
  # shellcheck disable=SC2059
  printf "\\n[BOOTSTRAP] ${fmt}\\n" "$@"
}

bootstrap_info() {
  local fmt="$1"
  shift
  # shellcheck disable=SC2059
  printf "[INFO] ${fmt}\\n" "$@"
}

bootstrap_warn() {
  local fmt="$1"
  shift
  # shellcheck disable=SC2059
  printf "[WARN] ${fmt}\\n" "$@" >&2
}

bootstrap_error() {
  local fmt="$1"
  shift
  # shellcheck disable=SC2059
  printf "[ERROR] ${fmt}\\n" "$@" >&2
}

run_cmd() {
  local cmd="$1"
  local description="${2:-}"

  if [[ "${DRY_RUN}" == "true" ]]; then
    bootstrap_info "[DRY RUN] Would run: %s" "${cmd}"
    if [[ -n "${description}" ]]; then
      bootstrap_info "  Purpose: %s" "${description}"
    fi
  else
    bootstrap_info "Running: %s" "${cmd}"
    eval "${cmd}"
  fi
}

show_help() {
  cat <<EOF
Usage: $0 [OPTIONS]

Bootstrap a fresh Mac from zero. Installs prerequisites, clones dotfiles,
runs setup.sh, installs language runtimes, and configures the default shell.

Options:
  --dry-run            Show what would be done without making changes
  --skip-brew-bundle   Skip the full Brewfile install (fastest re-run)
  --help               Show this help message

Examples:
  bash <(curl -fsSL https://raw.githubusercontent.com/pyeh/dotfiles/master/scripts/bootstrap.sh)
  $0                      # Full bootstrap
  $0 --dry-run            # Preview all phases
  $0 --skip-brew-bundle   # Skip lengthy Brewfile install
EOF
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      --dry-run)
        DRY_RUN=true
        shift
        ;;
      --skip-brew-bundle)
        SKIP_BREW_BUNDLE=true
        shift
        ;;
      --help)
        show_help
        exit 0
        ;;
      *)
        bootstrap_error "Unknown option: %s" "$1"
        show_help
        exit 1
        ;;
    esac
  done
}

preflight() {
  bootstrap_echo "Phase 0: Preflight checks"

  local osname
  osname="$(uname)"
  if [[ "${osname}" != "Darwin" ]]; then
    bootstrap_error "This script only supports macOS. Current OS: %s" "${osname}"
    exit 1
  fi
  bootstrap_info "macOS detected"

  local arch
  arch="$(uname -m)"
  if [[ "${arch}" == "arm64" ]]; then
    HOMEBREW_PREFIX="/opt/homebrew"
    bootstrap_info "Apple Silicon detected — HOMEBREW_PREFIX=%s" "${HOMEBREW_PREFIX}"
  else
    HOMEBREW_PREFIX="/usr/local"
    bootstrap_info "Intel Mac detected — HOMEBREW_PREFIX=%s" "${HOMEBREW_PREFIX}"
  fi

  if [[ "${DRY_RUN}" == "true" ]]; then
    bootstrap_echo "DRY RUN MODE — no changes will be made"
  fi
}

# ---------------------------------------------------------------------------
# Phase 1: Xcode Command Line Tools
# ---------------------------------------------------------------------------

install_xcode_cli_tools() {
  bootstrap_echo "Phase 1: Xcode Command Line Tools"

  if xcode-select -p &>/dev/null; then
    bootstrap_info "Xcode CLI tools already installed"
    return
  fi

  if [[ "${DRY_RUN}" == "true" ]]; then
    bootstrap_info "[DRY RUN] Would install Xcode CLI tools"
    return
  fi

  bootstrap_info "Installing Xcode Command Line Tools..."
  xcode-select --install

  bootstrap_info "Waiting for Xcode CLI tools installation to complete..."
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
  bootstrap_info "Xcode CLI tools installed"
}

# ---------------------------------------------------------------------------
# Phase 2: Rosetta 2 (Apple Silicon only)
# ---------------------------------------------------------------------------

install_rosetta() {
  bootstrap_echo "Phase 2: Rosetta 2"

  if [[ "$(uname -m)" != "arm64" ]]; then
    bootstrap_info "Not Apple Silicon — skipping Rosetta"
    return
  fi

  if pkgutil --pkg-info=com.apple.pkg.RosettaUpdateAuto &>/dev/null; then
    bootstrap_info "Rosetta 2 already installed"
    return
  fi

  run_cmd "softwareupdate --install-rosetta --agree-to-license" "Install Rosetta 2"
}

# ---------------------------------------------------------------------------
# Phase 3: Homebrew + Minimal Formulae
# ---------------------------------------------------------------------------

install_homebrew() {
  bootstrap_echo "Phase 3: Homebrew + minimal formulae"

  if command -v "${HOMEBREW_PREFIX}/bin/brew" &>/dev/null; then
    bootstrap_info "Homebrew already installed"
  else
    if [[ "${DRY_RUN}" == "true" ]]; then
      bootstrap_info "[DRY RUN] Would install Homebrew"
    else
      bootstrap_info "Installing Homebrew..."
      NONINTERACTIVE=1 /bin/bash -c \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  fi

  # Ensure brew is on PATH for this session
  if [[ "${DRY_RUN}" == "false" ]]; then
    eval "$("${HOMEBREW_PREFIX}/bin/brew" shellenv)"
  fi

  # Minimal formulae needed for subsequent phases
  local minimal_formulae=(git stow coreutils openssl@3 libyaml readline zsh)

  bootstrap_info "Installing minimal formulae: %s" "${minimal_formulae[*]}"
  for formula in "${minimal_formulae[@]}"; do
    if [[ "${DRY_RUN}" == "true" ]]; then
      bootstrap_info "[DRY RUN] Would install: %s" "${formula}"
    else
      brew install "${formula}" 2>/dev/null || true
    fi
  done
}

# ---------------------------------------------------------------------------
# Phase 4: Clone Dotfiles
# ---------------------------------------------------------------------------

clone_dotfiles() {
  bootstrap_echo "Phase 4: Clone dotfiles"

  if [[ -d "${DOTFILES_DIR}" ]]; then
    bootstrap_info "Dotfiles directory already exists at %s" "${DOTFILES_DIR}"
    if [[ "${DRY_RUN}" == "true" ]]; then
      bootstrap_info "[DRY RUN] Would pull latest changes"
    else
      bootstrap_info "Pulling latest changes..."
      git -C "${DOTFILES_DIR}" pull --ff-only || bootstrap_warn "Could not fast-forward; continuing with existing checkout"
    fi
  else
    run_cmd "git clone -b '${DOTFILES_BRANCH}' '${DOTFILES_REPO}' '${DOTFILES_DIR}'" \
      "Clone dotfiles repo"
  fi
}

# ---------------------------------------------------------------------------
# Phase 5: Run setup.sh
# ---------------------------------------------------------------------------

run_setup_sh() {
  bootstrap_echo "Phase 5: Run setup.sh"

  local setup_cmd="bash '${DOTFILES_DIR}/setup.sh'"
  if [[ "${DRY_RUN}" == "true" ]]; then
    setup_cmd="${setup_cmd} --dry-run"
  fi

  run_cmd "${setup_cmd}" "Run dotfiles setup (stow symlinks, hostname, directories, tmux)"
}

# ---------------------------------------------------------------------------
# Phase 6: asdf + Language Runtimes
# ---------------------------------------------------------------------------

add_or_update_asdf_plugin() {
  local name="$1"
  local url="$2"

  if [[ "${DRY_RUN}" == "true" ]]; then
    bootstrap_info "[DRY RUN] Would add/update asdf plugin: %s" "${name}"
    return
  fi

  if ! asdf plugin list 2>/dev/null | grep -Fq "${name}"; then
    asdf plugin add "${name}" "${url}"
  else
    asdf plugin update "${name}"
  fi
}

install_asdf_language() {
  local language="$1"

  if [[ "${DRY_RUN}" == "true" ]]; then
    bootstrap_info "[DRY RUN] Would install asdf language: %s" "${language}"
    return
  fi

  local versions
  # Read versions for this language from .tool-versions
  versions="$(grep "^${language} " "${HOME}/.tool-versions" | sed "s/^${language} //")"

  if [[ -z "${versions}" ]]; then
    bootstrap_warn "No version found for %s in .tool-versions" "${language}"
    return
  fi

  for version in ${versions}; do
    if asdf list "${language}" 2>/dev/null | grep -Fq "${version}"; then
      bootstrap_info "%s %s already installed" "${language}" "${version}"
    else
      bootstrap_info "Installing %s %s ..." "${language}" "${version}"
      asdf install "${language}" "${version}"
    fi
  done
}

install_asdf_languages() {
  bootstrap_echo "Phase 6: asdf + language runtimes"

  if [[ "${DRY_RUN}" == "false" ]]; then
    brew install asdf 2>/dev/null || true
    # shellcheck source=/dev/null
    source "$(brew --prefix asdf)/libexec/asdf.sh" 2>/dev/null || true
  else
    bootstrap_info "[DRY RUN] Would install asdf via Homebrew"
  fi

  add_or_update_asdf_plugin "ruby" "https://github.com/asdf-vm/asdf-ruby.git"
  add_or_update_asdf_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"
  add_or_update_asdf_plugin "python" "https://github.com/asdf-community/asdf-python.git"
  add_or_update_asdf_plugin "lua" "https://github.com/Stratus3D/asdf-lua.git"

  install_asdf_language "ruby"
  install_asdf_language "nodejs"
  install_asdf_language "python"
  install_asdf_language "lua"

  # Configure bundler parallelism
  if [[ "${DRY_RUN}" == "true" ]]; then
    bootstrap_info "[DRY RUN] Would configure bundler jobs"
  else
    local num_cpus
    num_cpus="$(sysctl -n hw.ncpu)"
    bundle config --global jobs "$((num_cpus - 1))" 2>/dev/null || true
  fi
}

# ---------------------------------------------------------------------------
# Phase 7: Gems + npm Packages
# ---------------------------------------------------------------------------

gem_install_or_update() {
  local gem_name="$1"

  if gem list "${gem_name}" --installed >/dev/null 2>&1; then
    bootstrap_info "Updating gem: %s" "${gem_name}"
    gem update "${gem_name}" --no-document || true
  else
    bootstrap_info "Installing gem: %s" "${gem_name}"
    gem install "${gem_name}" --no-document || true
  fi
}

install_gems_and_npm() {
  bootstrap_echo "Phase 7: Gems + npm packages"

  # Install gems from ~/.default-gems
  if [[ -f "${HOME}/.default-gems" ]]; then
    bootstrap_info "Installing gems from ~/.default-gems ..."
    if [[ "${DRY_RUN}" == "true" ]]; then
      bootstrap_info "[DRY RUN] Would install gems: %s" "$(tr '\n' ' ' <"${HOME}/.default-gems")"
    else
      while IFS= read -r gem_name; do
        [[ -z "${gem_name}" ]] && continue
        gem_install_or_update "${gem_name}"
      done <"${HOME}/.default-gems"
    fi
  else
    bootstrap_warn "%s/.default-gems not found — skipping gem installation" "${HOME}"
  fi

  # Install npm packages from ~/.default-npm-packages
  if [[ -f "${HOME}/.default-npm-packages" ]]; then
    bootstrap_info "Installing npm packages from ~/.default-npm-packages ..."
    if [[ "${DRY_RUN}" == "true" ]]; then
      bootstrap_info "[DRY RUN] Would install npm packages: %s" "$(tr '\n' ' ' <"${HOME}/.default-npm-packages")"
    else
      while IFS= read -r pkg_name; do
        [[ -z "${pkg_name}" ]] && continue
        bootstrap_info "Installing npm package: %s" "${pkg_name}"
        npm install -g "${pkg_name}" || bootstrap_warn "Failed to install npm package: %s" "${pkg_name}"
      done <"${HOME}/.default-npm-packages"
    fi
  else
    bootstrap_warn "%s/.default-npm-packages not found — skipping npm installation" "${HOME}"
  fi
}

# ---------------------------------------------------------------------------
# Phase 8: Zsh + Zap
# ---------------------------------------------------------------------------

setup_zsh() {
  bootstrap_echo "Phase 8: Zsh + Zap"

  local brew_zsh="${HOMEBREW_PREFIX}/bin/zsh"

  # Add Homebrew zsh to /etc/shells if missing
  if ! grep -Fq "${brew_zsh}" /etc/shells 2>/dev/null; then
    run_cmd "echo '${brew_zsh}' | sudo tee -a /etc/shells" \
      "Add Homebrew Zsh to /etc/shells"
  else
    bootstrap_info "Homebrew Zsh already in /etc/shells"
  fi

  # Set as default shell
  if [[ "${SHELL}" != "${brew_zsh}" ]]; then
    run_cmd "chsh -s '${brew_zsh}'" "Set Homebrew Zsh as default shell"
  else
    bootstrap_info "Homebrew Zsh already the default shell"
  fi

  # Install Zap plugin manager
  if [[ -d "${HOME}/.local/share/zap" ]]; then
    bootstrap_info "Zap already installed"
  else
    if [[ "${DRY_RUN}" == "true" ]]; then
      bootstrap_info "[DRY RUN] Would install Zap (Zsh plugin manager) with --keep flag"
    else
      bootstrap_info "Installing Zap (Zsh plugin manager)..."
      zsh <(curl -fsSL https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1 --keep
    fi
  fi
}

# ---------------------------------------------------------------------------
# Phase 9: brew bundle install
# ---------------------------------------------------------------------------

run_brew_bundle() {
  bootstrap_echo "Phase 9: brew bundle install"

  if [[ "${SKIP_BREW_BUNDLE}" == "true" ]]; then
    bootstrap_info "Skipping brew bundle install (--skip-brew-bundle)"
    return
  fi

  if [[ ! -f "${HOME}/Brewfile" ]]; then
    bootstrap_warn "%s/Brewfile not found — skipping brew bundle" "${HOME}"
    return
  fi

  run_cmd "brew bundle install --file='${HOME}/Brewfile'" \
    "Install packages from Brewfile (this may take a while)"
}

# ---------------------------------------------------------------------------
# Phase 10: Summary
# ---------------------------------------------------------------------------

show_summary() {
  bootstrap_echo "Phase 10: Bootstrap complete!"

  cat <<'EOF'

Remaining manual steps:
  -> Launch nvim and run :checkhealth
  -> Create ~/.gitconfig.local with your name and email
  -> Install Tmux plugins: start tmux, then press <prefix> + I
  -> Restart your terminal to pick up all changes

EOF
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

main() {
  parse_args "$@"
  preflight

  install_xcode_cli_tools
  install_rosetta
  install_homebrew
  clone_dotfiles
  run_setup_sh
  install_asdf_languages
  install_gems_and_npm
  setup_zsh
  run_brew_bundle
  show_summary
}

trap 'bootstrap_error "Script failed at line %s" "$LINENO"' ERR

main "$@"
