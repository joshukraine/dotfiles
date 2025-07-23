#!/bin/bash
#
# Shell Syntax Validator
#
# Validates syntax of Fish, Zsh, and shell script files
# Integrates shellcheck for comprehensive shell script analysis
#
# Exit codes:
#   0 - All syntax validation passed
#   1 - Syntax errors found
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
    echo "SHELL_SYNTAX_SUCCESS: $1" >&2
  fi
}

log_warning() {
  if [[ ${CI_MODE} -eq 0 ]]; then
    echo "  ⚠ $1" >&2
  else
    echo "SHELL_SYNTAX_WARNING: $1" >&2
  fi
  ((WARNINGS++))
}

log_error() {
  if [[ ${CI_MODE} -eq 0 ]]; then
    echo "  ✗ $1" >&2
  else
    echo "SHELL_SYNTAX_ERROR: $1" >&2
  fi
  ((VALIDATION_ERRORS++))
}

# Check if required tools are available
check_prerequisites() {
  local missing_tools=()

  # Check for fish
  if ! command -v fish > /dev/null 2>&1; then
    missing_tools+=("fish")
  fi

  # Check for zsh
  if ! command -v zsh > /dev/null 2>&1; then
    missing_tools+=("zsh")
  fi

  # Check for shellcheck
  if ! command -v shellcheck > /dev/null 2>&1; then
    missing_tools+=("shellcheck")
  fi

  # Check for shfmt (required for formatting when --fix is enabled)
  if [[ ${FIX_MODE} -eq 1 ]] && ! command -v shfmt > /dev/null 2>&1; then
    missing_tools+=("shfmt")
  fi

  if [[ ${#missing_tools[@]} -gt 0 ]]; then
    log_error "Missing required tools: ${missing_tools[*]}"
    log_error "Install with: brew install ${missing_tools[*]}"
    return 1
  fi

  return 0
}

# Validate Fish configuration files
validate_fish_files() {
  log_info "Validating Fish configuration files..."

  local fish_files=()
  while IFS= read -r file; do
    fish_files+=("${file}")
  done < <(find "${DOTFILES_ROOT}/fish" -name "*.fish" -type f 2> /dev/null || true)

  if [[ ${#fish_files[@]} -eq 0 ]]; then
    log_warning "No Fish files found to validate"
    return 0
  fi

  local fish_errors=0
  for file in "${fish_files[@]}"; do
    local relative_file="${file#"${DOTFILES_ROOT}"/}"

    # Check Fish syntax
    if fish -n "${file}" 2> /dev/null; then
      log_success "Fish syntax valid: ${relative_file}"
    else
      log_error "Fish syntax error: ${relative_file}"

      # Show detailed error if verbose
      if [[ ${VERBOSE} -eq 1 ]]; then
        echo "    Error details:"
        fish -n "${file}" 2>&1 | sed 's/^/      /' >&2 || true
      fi

      ((fish_errors++))
    fi
  done

  if [[ ${fish_errors} -gt 0 ]]; then
    log_error "Found ${fish_errors} Fish syntax error(s)"
    return 1
  fi

  log_success "All Fish files have valid syntax"
  return 0
}

# Validate Zsh configuration files
validate_zsh_files() {
  log_info "Validating Zsh configuration files..."

  local zsh_files=()
  while IFS= read -r file; do
    zsh_files+=("${file}")
  done < <(find "${DOTFILES_ROOT}/zsh" -name "*.zsh" -o -name ".zshrc" -type f 2> /dev/null || true)

  if [[ ${#zsh_files[@]} -eq 0 ]]; then
    log_warning "No Zsh files found to validate"
    return 0
  fi

  local zsh_errors=0
  for file in "${zsh_files[@]}"; do
    local relative_file="${file#"${DOTFILES_ROOT}"/}"

    # Check Zsh syntax using zsh -n (dry run)
    if zsh -n "${file}" 2> /dev/null; then
      log_success "Zsh syntax valid: ${relative_file}"
    else
      log_error "Zsh syntax error: ${relative_file}"

      # Show detailed error if verbose
      if [[ ${VERBOSE} -eq 1 ]]; then
        echo "    Error details:"
        zsh -n "${file}" 2>&1 | sed 's/^/      /' >&2 || true
      fi

      ((zsh_errors++))
    fi
  done

  if [[ ${zsh_errors} -gt 0 ]]; then
    log_error "Found ${zsh_errors} Zsh syntax error(s)"
    return 1
  fi

  log_success "All Zsh files have valid syntax"
  return 0
}

# Auto-fix shellcheck issues using shellcheck's built-in diff functionality
fix_shellcheck_issues() {
  local file="$1"
  local diff_output
  local temp_patch
  temp_patch=$(mktemp)
  local original_dir
  original_dir=$(pwd)

  # Generate shellcheck auto-fix diff with timeout
  diff_output=$(timeout 30s shellcheck -f diff "${file}" 2> /dev/null || true)

  if [[ -n "${diff_output}" && "${diff_output}" != "" ]]; then
    # Save the diff to a temp file and apply it
    echo "${diff_output}" > "${temp_patch}"

    # Apply the patch from the dotfiles root directory (save/restore working dir)
    if cd "${DOTFILES_ROOT}" 2> /dev/null; then
      if timeout 10s patch --batch --forward -p1 < "${temp_patch}" > /dev/null 2>&1; then
        cd "${original_dir}"
        log_info "Applied shellcheck auto-fixes to $(basename "${file}")"
        rm -f "${temp_patch}"
        return 0
      else
        # Try applying without path stripping in case of relative paths
        if timeout 10s patch --batch --forward -p0 < "${temp_patch}" > /dev/null 2>&1; then
          cd "${original_dir}"
          log_info "Applied shellcheck auto-fixes to $(basename "${file}")"
          rm -f "${temp_patch}"
          return 0
        fi
      fi
      # Always restore working directory
      cd "${original_dir}"
    fi

    log_warning "Failed to apply auto-fixes to $(basename "${file}")"
    rm -f "${temp_patch}"
    return 1
  fi

  # Clean up and return
  rm -f "${temp_patch}"
  return 1
}

# Format shell script using shfmt
format_shell_script() {
  local file="$1"
  local temp_formatted
  temp_formatted=$(mktemp)
  local original_content_hash
  local formatted_content_hash

  # Get hash of original file content
  original_content_hash=$(sha256sum "${file}" | cut -d' ' -f1)

  # Apply shfmt formatting with recommended options:
  # -i 2: 2-space indentation
  # -ci: Switch cases indent
  # -bn: Binary operators at beginning of line
  # -sr: Redirect operators followed by space
  if timeout 30s shfmt -i 2 -ci -bn -sr "${file}" > "${temp_formatted}" 2> /dev/null; then
    # Get hash of formatted content
    formatted_content_hash=$(sha256sum "${temp_formatted}" | cut -d' ' -f1)

    # Only update file if content actually changed
    if [[ "${original_content_hash}" != "${formatted_content_hash}" ]]; then
      if cp "${temp_formatted}" "${file}"; then
        log_info "Applied shfmt formatting to $(basename "${file}")"
        rm -f "${temp_formatted}"
        return 0
      else
        log_warning "Failed to apply shfmt formatting to $(basename "${file}")"
        rm -f "${temp_formatted}"
        return 1
      fi
    else
      # File was already properly formatted
      rm -f "${temp_formatted}"
      return 0
    fi
  else
    log_warning "shfmt formatting failed for $(basename "${file}")"
    rm -f "${temp_formatted}"
    return 1
  fi
}

# Validate shell scripts with shellcheck
validate_shell_scripts() {
  log_info "Validating shell scripts with shellcheck..."

  local shell_files=()
  while IFS= read -r file; do
    shell_files+=("${file}")
  done < <(
    find "${DOTFILES_ROOT}" \
      -name "*.sh" -o -name "*.bash" \
      -not -path "*/.*" \
      -not -path "*/node_modules/*" \
      -not -path "*/vendor/*" \
      -type f 2> /dev/null || true
  )

  if [[ ${#shell_files[@]} -eq 0 ]]; then
    log_warning "No shell scripts found to validate"
    return 0
  fi

  local shellcheck_errors=0
  local shellcheck_warnings=0

  for file in "${shell_files[@]}"; do
    local relative_file="${file#"${DOTFILES_ROOT}"/}"

    # Attempt auto-fixes if fix mode is enabled
    if [[ ${FIX_MODE} -eq 1 ]]; then
      # Check if file has fixable issues before attempting fixes
      local pre_fix_output
      pre_fix_output=$(shellcheck -f gcc "${file}" 2>&1 | head -20 || true)

      if [[ -n "${pre_fix_output}" ]] && echo "${pre_fix_output}" | grep -q "SC225[0-9]\|SC2034\|SC2086\|SC2250"; then
        if fix_shellcheck_issues "${file}"; then
          log_info "Applied auto-fixes to ${relative_file}"
        fi
      fi

      # Apply shfmt formatting after shellcheck fixes
      if command -v shfmt > /dev/null 2>&1; then
        format_shell_script "${file}"
      fi
    fi

    # Run shellcheck on the file (with timeout to prevent hanging)
    local shellcheck_output
    local shellcheck_exit_code=0

    shellcheck_output=$(timeout 30s shellcheck -f gcc "${file}" 2>&1 || echo "shellcheck-timeout") || shellcheck_exit_code=$?

    # Handle timeout case
    if [[ "${shellcheck_output}" == "shellcheck-timeout" ]]; then
      log_error "Shellcheck timed out: ${relative_file}"
      ((shellcheck_errors++))
      continue
    fi

    if [[ ${shellcheck_exit_code} -eq 0 ]]; then
      log_success "Shellcheck passed: ${relative_file}"
    else
      # Parse shellcheck output to distinguish errors from warnings
      local has_errors=0
      local has_warnings=0

      while IFS= read -r line; do
        if [[ -n "${line}" ]]; then
          if [[ "${line}" =~ error ]]; then
            has_errors=1
          elif [[ "${line}" =~ warning ]]; then
            has_warnings=1
          fi

          if [[ ${VERBOSE} -eq 1 ]]; then
            echo "    ${line}" >&2
          fi
        fi
      done <<< "${shellcheck_output}"

      if [[ ${has_errors} -eq 1 ]]; then
        log_error "Shellcheck errors: ${relative_file}"
        ((shellcheck_errors++))
      elif [[ ${has_warnings} -eq 1 ]]; then
        log_warning "Shellcheck warnings: ${relative_file}"
        ((shellcheck_warnings++))
      else
        # Shellcheck failed but output doesn't contain 'error' or 'warning'
        log_error "Shellcheck failed: ${relative_file}"
        ((shellcheck_errors++))
      fi
    fi
  done

  # Report results
  if [[ ${shellcheck_errors} -gt 0 ]]; then
    log_error "Found ${shellcheck_errors} shellcheck error(s)"
    if [[ ${shellcheck_warnings} -gt 0 ]]; then
      log_warning "Found ${shellcheck_warnings} shellcheck warning(s)"
    fi
    return 1
  elif [[ ${shellcheck_warnings} -gt 0 ]]; then
    log_warning "Found ${shellcheck_warnings} shellcheck warning(s)"
    log_success "No shellcheck errors found"
    return 0
  else
    log_success "All shell scripts passed shellcheck"
    return 0
  fi
}

# Special validation for setup.sh and other critical scripts
validate_critical_scripts() {
  log_info "Validating critical scripts..."

  local critical_scripts=(
    "${DOTFILES_ROOT}/setup.sh"
    "${DOTFILES_ROOT}/shared/generate-all-abbr.sh"
  )

  local critical_errors=0

  for script in "${critical_scripts[@]}"; do
    if [[ ! -f "${script}" ]]; then
      log_warning "Critical script not found: ${script#"${DOTFILES_ROOT}"/}"
      continue
    fi

    local relative_script="${script#"${DOTFILES_ROOT}"/}"

    # Check if script is executable
    if [[ ! -x "${script}" ]]; then
      log_error "Critical script not executable: ${relative_script}"
      ((critical_errors++))

      if [[ ${FIX_MODE} -eq 1 ]]; then
        log_info "Fixing: Making ${relative_script} executable"
        chmod +x "${script}"
        log_success "Fixed: ${relative_script} is now executable"
      fi
    else
      log_success "Critical script executable: ${relative_script}"
    fi

    # Validate syntax (already covered by shellcheck above, but double-check)
    if bash -n "${script}" 2> /dev/null; then
      log_success "Critical script syntax valid: ${relative_script}"
    else
      log_error "Critical script syntax error: ${relative_script}"
      ((critical_errors++))
    fi
  done

  if [[ ${critical_errors} -gt 0 ]]; then
    log_error "Found ${critical_errors} critical script error(s)"
    return 1
  fi

  return 0
}

# Main validation function
main() {
  local validation_failed=0

  # Change to dotfiles root
  cd "${DOTFILES_ROOT}"

  # Check prerequisites
  if ! check_prerequisites; then
    return 2
  fi

  # Run all syntax validations
  if ! validate_fish_files; then
    validation_failed=1
  fi

  if ! validate_zsh_files; then
    validation_failed=1
  fi

  if ! validate_shell_scripts; then
    validation_failed=1
  fi

  if ! validate_critical_scripts; then
    validation_failed=1
  fi

  # Summary
  if [[ ${validation_failed} -eq 1 ]]; then
    log_error "Shell syntax validation failed with ${VALIDATION_ERRORS} error(s)"
    if [[ ${WARNINGS} -gt 0 ]]; then
      log_warning "Total warnings: ${WARNINGS}"
    fi
    return 1
  else
    log_success "Shell syntax validation passed"
    if [[ ${WARNINGS} -gt 0 ]]; then
      log_warning "Total warnings: ${WARNINGS}"
    fi
    return 0
  fi
}

# Run main function
main
