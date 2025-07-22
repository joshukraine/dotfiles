#!/bin/bash
#
# Environment Variables Validator
#
# Validates environment variable configuration for consistency and correctness:
# - Syntax validation for both Shell and Fish environment files
# - Consistency verification between parallel environment files
# - Required environment variable presence checks
# - Path variable validation
# - Potential conflict detection
#
# Exit codes:
#   0 - All environment validation passed
#   1 - Validation errors found
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

# File paths
BASH_ENV_FILE="$DOTFILES_ROOT/shared/environment.sh"
FISH_ENV_FILE="$DOTFILES_ROOT/shared/environment.fish"

# Logging functions
log_info() {
  if [[ $VERBOSE -eq 1 && $CI_MODE -eq 0 ]]; then
    echo "  ℹ $1" >&2
  fi
}

log_success() {
  if [[ $CI_MODE -eq 0 ]]; then
    echo "  ✓ $1" >&2
  else
    echo "ENVIRONMENT_SUCCESS: $1" >&2
  fi
}

log_warning() {
  if [[ $CI_MODE -eq 0 ]]; then
    echo "  ⚠ $1" >&2
  else
    echo "ENVIRONMENT_WARNING: $1" >&2
  fi
  ((WARNINGS++))
}

log_error() {
  if [[ $CI_MODE -eq 0 ]]; then
    echo "  ✗ $1" >&2
  else
    echo "ENVIRONMENT_ERROR: $1" >&2
  fi
  ((VALIDATION_ERRORS++))
}

# Check if required environment files exist
check_environment_files() {
  log_info "Checking environment files..."

  local files_missing=()

  if [[ ! -f "$BASH_ENV_FILE" ]]; then
    files_missing+=("shared/environment.sh")
  fi

  if [[ ! -f "$FISH_ENV_FILE" ]]; then
    files_missing+=("shared/environment.fish")
  fi

  if [[ ${#files_missing[@]} -gt 0 ]]; then
    for file in "${files_missing[@]}"; do
      log_error "Environment file missing: $file"
    done
    return 1
  fi

  log_success "Environment files found"
  return 0
}

# Validate syntax of shell environment file
validate_bash_environment_syntax() {
  log_info "Validating bash environment syntax..."

  # Check bash syntax
  if bash -n "$BASH_ENV_FILE" 2>/dev/null; then
    log_success "Bash environment syntax valid"
  else
    log_error "Bash environment syntax error: shared/environment.sh"

    if [[ $VERBOSE -eq 1 ]]; then
      echo "    Error details:"
      bash -n "$BASH_ENV_FILE" 2>&1 | sed 's/^/      /' >&2 || true
    fi
    return 1
  fi

  # Check for proper shebang
  if ! head -1 "$BASH_ENV_FILE" | grep -q "#!/usr/bin/env bash"; then
    log_warning "Bash environment file missing proper shebang"
  fi

  return 0
}

# Validate syntax of fish environment file
validate_fish_environment_syntax() {
  log_info "Validating fish environment syntax..."

  # Check fish syntax
  if fish -n "$FISH_ENV_FILE" 2>/dev/null; then
    log_success "Fish environment syntax valid"
  else
    log_error "Fish environment syntax error: shared/environment.fish"

    if [[ $VERBOSE -eq 1 ]]; then
      echo "    Error details:"
      fish -n "$FISH_ENV_FILE" 2>&1 | sed 's/^/      /' >&2 || true
    fi
    return 1
  fi

  return 0
}

# Extract environment variables from bash file
extract_bash_variables() {
  grep -E "^export [A-Z_]+=" "$BASH_ENV_FILE" 2>/dev/null | \
    sed 's/^export //; s/=.*//' | \
    sort || echo ""
}

# Extract environment variables from fish file
extract_fish_variables() {
  grep -E "^set -gx [A-Z_]+" "$FISH_ENV_FILE" 2>/dev/null | \
    sed 's/^set -gx //; s/ .*//' | \
    sort || echo ""
}

# Validate consistency between bash and fish environment files
validate_environment_consistency() {
  log_info "Validating environment file consistency..."

  local bash_vars fish_vars
  bash_vars=$(extract_bash_variables)
  fish_vars=$(extract_fish_variables)

  if [[ -z "$bash_vars" ]]; then
    log_error "No environment variables found in bash file"
    return 1
  fi

  if [[ -z "$fish_vars" ]]; then
    log_error "No environment variables found in fish file"
    return 1
  fi

  # Count variables
  local bash_count fish_count
  bash_count=$(echo "$bash_vars" | grep -c . || echo "0")
  fish_count=$(echo "$fish_vars" | grep -c . || echo "0")

  log_info "Environment variables - Bash: $bash_count, Fish: $fish_count"

  # Check for missing variables in fish file
  local missing_in_fish
  missing_in_fish=$(comm -23 <(echo "$bash_vars") <(echo "$fish_vars") || echo "")

  if [[ -n "$missing_in_fish" ]]; then
    log_error "Variables missing from Fish environment file:"
    echo "$missing_in_fish" | while read -r var; do
      if [[ -n "$var" ]]; then
        log_error "  - $var"
      fi
    done
  fi

  # Check for missing variables in bash file
  local missing_in_bash
  missing_in_bash=$(comm -13 <(echo "$bash_vars") <(echo "$fish_vars") || echo "")

  if [[ -n "$missing_in_bash" ]]; then
    log_error "Variables missing from Bash environment file:"
    echo "$missing_in_bash" | while read -r var; do
      if [[ -n "$var" ]]; then
        log_error "  - $var"
      fi
    done
  fi

  # Check if counts match (allowing for small differences)
  local diff=$((bash_count - fish_count))
  if [[ ${diff#-} -gt 2 ]]; then
    log_warning "Significant difference in variable count ($bash_count vs $fish_count)"
  fi

  if [[ -z "$missing_in_fish" && -z "$missing_in_bash" ]]; then
    log_success "Environment files have consistent variable definitions"
  fi

  return 0
}

# Validate that required environment variables are defined
validate_required_variables() {
  log_info "Checking required environment variables..."

  # Essential variables that should be defined
  local required_vars=(
    "EDITOR"
    "XDG_CONFIG_HOME"
    "XDG_DATA_HOME"
    "XDG_CACHE_HOME"
    "DOTFILES"
  )

  local missing_required=()

  for var in "${required_vars[@]}"; do
    if ! grep -q "export $var=" "$BASH_ENV_FILE" 2>/dev/null; then
      missing_required+=("$var")
    fi
  done

  if [[ ${#missing_required[@]} -gt 0 ]]; then
    log_error "Required environment variables missing:"
    for var in "${missing_required[@]}"; do
      log_error "  - $var"
    done
    return 1
  fi

  log_success "All required environment variables are defined"
  return 0
}

# Validate environment variable values for common issues
validate_variable_values() {
  log_info "Validating environment variable values..."

  local validation_errors=0

  # Check EDITOR value
  if grep -q 'export EDITOR=' "$BASH_ENV_FILE" 2>/dev/null; then
    local editor_value
    editor_value=$(grep 'export EDITOR=' "$BASH_ENV_FILE" | sed 's/.*export EDITOR="//; s/".*//' || echo "")

    if [[ -n "$editor_value" ]]; then
      if ! command -v "$editor_value" >/dev/null 2>&1; then
        log_warning "EDITOR '$editor_value' not found in PATH"
      else
        log_success "EDITOR '$editor_value' is available"
      fi
    fi
  fi

  # Check XDG directory structure
  local xdg_vars=("XDG_CONFIG_HOME" "XDG_DATA_HOME" "XDG_CACHE_HOME" "XDG_STATE_HOME")
  for xdg_var in "${xdg_vars[@]}"; do
    if grep -q "export $xdg_var=" "$BASH_ENV_FILE" 2>/dev/null; then
      local xdg_value
      xdg_value=$(grep "export $xdg_var=" "$BASH_ENV_FILE" | sed 's/.*export [^=]*="//; s/".*//' || echo "")

      # Check if it uses $HOME (good practice)
      if [[ "$xdg_value" != *"\$HOME"* ]]; then
        log_warning "$xdg_var should use \$HOME for portability: $xdg_value"
      fi
    fi
  done

  # Check for absolute paths that might not be portable
  while IFS= read -r line; do
    if [[ "$line" =~ export.*=\"/[^$] ]]; then
      local var_name
      var_name=$(echo "$line" | sed 's/export //; s/=.*//')
      local var_value
      var_value=$(echo "$line" | sed 's/.*export [^=]*="//; s/".*//')

      # Skip known good absolute paths
      case "$var_name" in
        SSH_AUTH_SOCK|HOMEBREW_CASK_OPTS)
          continue
          ;;
        *)
          log_warning "Absolute path in $var_name may not be portable: $var_value"
          ;;
      esac
    fi
  done < <(grep "^export" "$BASH_ENV_FILE" 2>/dev/null || echo "")

  if [[ $validation_errors -eq 0 ]]; then
    log_success "Environment variable values validated"
  fi

  return 0
}

# Check for potential conflicts or issues
validate_environment_health() {
  log_info "Checking environment health..."

  # Check for duplicate variable definitions
  local duplicates
  duplicates=$(extract_bash_variables | uniq -d)

  if [[ -n "$duplicates" ]]; then
    log_error "Duplicate variable definitions found:"
    echo "$duplicates" | while read -r var; do
      if [[ -n "$var" ]]; then
        log_error "  - $var"
      fi
    done
  fi

  # Check for variables that might conflict with system defaults
  local potentially_problematic=("PATH" "HOME" "USER" "SHELL")
  for var in "${potentially_problematic[@]}"; do
    if grep -q "export $var=" "$BASH_ENV_FILE" 2>/dev/null; then
      log_warning "Modifying system variable '$var' - ensure this is intentional"
    fi
  done

  # Check file permissions
  local bash_perms fish_perms
  bash_perms=$(stat -f "%A" "$BASH_ENV_FILE" 2>/dev/null || echo "unknown")
  fish_perms=$(stat -f "%A" "$FISH_ENV_FILE" 2>/dev/null || echo "unknown")

  if [[ "$bash_perms" == "644" && "$fish_perms" == "644" ]]; then
    log_success "Environment files have correct permissions (644)"
  else
    log_warning "Environment files may have incorrect permissions (bash: $bash_perms, fish: $fish_perms)"
  fi

  log_success "Environment health check completed"
  return 0
}

# Main validation function
main() {
  local validation_failed=0

  # Change to dotfiles root
  cd "$DOTFILES_ROOT"

  # Run all environment validations
  if ! check_environment_files; then
    validation_failed=1
  fi

  if ! validate_bash_environment_syntax; then
    validation_failed=1
  fi

  if ! validate_fish_environment_syntax; then
    validation_failed=1
  fi

  if ! validate_environment_consistency; then
    validation_failed=1
  fi

  if ! validate_required_variables; then
    validation_failed=1
  fi

  if ! validate_variable_values; then
    validation_failed=1
  fi

  if ! validate_environment_health; then
    validation_failed=1
  fi

  # Summary
  if [[ $validation_failed -eq 1 ]]; then
    log_error "Environment validation failed with $VALIDATION_ERRORS error(s)"
    if [[ $WARNINGS -gt 0 ]]; then
      log_warning "Total warnings: $WARNINGS"
    fi
    return 1
  else
    log_success "Environment validation passed"
    if [[ $WARNINGS -gt 0 ]]; then
      log_warning "Total warnings: $WARNINGS"
    fi
    return 0
  fi
}

# Run main function
main
