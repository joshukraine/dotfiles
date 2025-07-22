#!/bin/bash
#
# Markdown Validator
#
# Validates markdown file formatting and style consistency:
# - Markdown syntax and formatting rules
# - Configuration from markdown/.markdownlint.yaml
# - Excludes scratchpads and external dependencies
# - Supports fix mode for auto-repairable issues
# - Integrates with existing validation framework
#
# Exit codes:
#   0 - All markdown validation passed
#   1 - Markdown formatting errors found
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
FILES_WITH_ERRORS=0
FILES_FIXED=0

# File paths
MARKDOWN_CONFIG="$DOTFILES_ROOT/markdown/.markdownlint.yaml"

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
    echo "MARKDOWN_SUCCESS: $1" >&2
  fi
}

log_warning() {
  if [[ $CI_MODE -eq 0 ]]; then
    echo "  ⚠ $1" >&2
  else
    echo "MARKDOWN_WARNING: $1" >&2
  fi
  ((WARNINGS++))
}

log_error() {
  if [[ $CI_MODE -eq 0 ]]; then
    echo "  ✗ $1" >&2
  else
    echo "MARKDOWN_ERROR: $1" >&2
  fi
  ((VALIDATION_ERRORS++))
}

# Check if required tools are available
check_prerequisites() {
  local missing_tools=()

  # Check for markdownlint-cli2
  if ! command -v markdownlint-cli2 >/dev/null 2>&1; then
    missing_tools+=("markdownlint-cli2")
  fi

  if [[ ${#missing_tools[@]} -gt 0 ]]; then
    log_error "Missing required tools: ${missing_tools[*]}"
    log_error "Install with: brew install ${missing_tools[*]}"
    return 1
  fi

  return 0
}

# Check markdown configuration file
check_markdown_config() {
  log_info "Checking markdown configuration..."

  if [[ ! -f "$MARKDOWN_CONFIG" ]]; then
    log_error "Markdown configuration not found: markdown/.markdownlint.yaml"
    return 1
  fi

  log_success "Markdown configuration found: markdown/.markdownlint.yaml"

  # Validate config file syntax (YAML)
  if command -v yq >/dev/null 2>&1; then
    if ! yq eval '.' "$MARKDOWN_CONFIG" >/dev/null 2>&1; then
      log_error "Invalid YAML syntax in markdown configuration"
      return 1
    fi
    log_success "Markdown configuration syntax valid"
  fi

  return 0
}

# Find markdown files to validate
find_markdown_files() {
  # Find all .md files excluding:
  # - scratchpads (temporary files)
  # - .git directory
  # - external plugins (tmux plugins, etc.)
  find "$DOTFILES_ROOT" \
    -name "*.md" \
    -not -path "*/scratchpads/*" \
    -not -path "*/.git/*" \
    -not -path "*/tmux/.config/tmux/plugins/*" \
    -not -path "*/node_modules/*" \
    -not -path "*/vendor/*" \
    -type f 2>/dev/null | sort || echo ""
}

# Validate a single markdown file
validate_markdown_file() {
  local file="$1"
  local relative_file="${file#"$DOTFILES_ROOT"/}"

  # Run markdownlint-cli2 on the file
  local lint_output
  local lint_exit_code=0

  if [[ $FIX_MODE -eq 1 ]]; then
    # Run with --fix flag
    lint_output=$(markdownlint-cli2 --config "$MARKDOWN_CONFIG" --fix "$file" 2>&1) || lint_exit_code=$?
  else
    # Run validation only
    lint_output=$(markdownlint-cli2 --config "$MARKDOWN_CONFIG" "$file" 2>&1) || lint_exit_code=$?
  fi

  if [[ $lint_exit_code -eq 0 ]]; then
    log_success "Markdown valid: $relative_file"
    if [[ $FIX_MODE -eq 1 && -n "$lint_output" ]]; then
      if echo "$lint_output" | grep -q "Fixed"; then
        log_success "Fixed issues in: $relative_file"
        ((FILES_FIXED++))
      fi
    fi
    return 0
  else
    log_error "Markdown errors: $relative_file"
    ((FILES_WITH_ERRORS++))

    # Show error details if verbose
    if [[ $VERBOSE -eq 1 ]]; then
      # Extract just the error messages (skip the summary lines)
      local error_lines
      error_lines=$(echo "$lint_output" | grep -E "^[^:]+:[0-9]+:[0-9]+" || true)
      if [[ -n "$error_lines" ]]; then
        echo "$error_lines" | while IFS= read -r line; do
          if [[ -n "$line" ]]; then
            echo "    $line" >&2
          fi
        done
      fi
    fi

    return 1
  fi
}

# Validate all markdown files
validate_all_markdown() {
  log_info "Validating markdown files..."

  local markdown_files=()
  while IFS= read -r file; do
    if [[ -n "$file" ]]; then
      markdown_files+=("$file")
    fi
  done < <(find_markdown_files)

  if [[ ${#markdown_files[@]} -eq 0 ]]; then
    log_warning "No markdown files found to validate"
    return 0
  fi

  log_info "Found ${#markdown_files[@]} markdown files to validate"

  local validation_failed=0
  for file in "${markdown_files[@]}"; do
    if ! validate_markdown_file "$file"; then
      validation_failed=1
    fi
  done

  # Summary
  if [[ $FIX_MODE -eq 1 && $FILES_FIXED -gt 0 ]]; then
    log_success "Fixed issues in $FILES_FIXED file(s)"
  fi

  if [[ $validation_failed -eq 1 ]]; then
    return 1
  fi

  return 0
}

# Check markdown tool version
check_markdown_version() {
  log_info "Checking markdownlint-cli2 version..."

  local version_output
  version_output=$(markdownlint-cli2 --version 2>&1 | head -1 || echo "unknown")

  if [[ "$version_output" =~ markdownlint-cli2[[:space:]]v([0-9]+\.[0-9]+) ]]; then
    log_success "Using $version_output"
  else
    log_warning "Could not determine markdownlint-cli2 version"
  fi

  return 0
}

# Run performance check
check_performance() {
  # Count total files being validated
  local file_count
  file_count=$(find_markdown_files | wc -l | tr -d ' ')

  if [[ $file_count -gt 50 ]]; then
    log_warning "Validating $file_count markdown files may impact performance"
  fi

  return 0
}

# Main validation function
main() {
  local validation_failed=0
  local start_time
  start_time=$(date +%s)

  # Change to dotfiles root
  cd "$DOTFILES_ROOT"

  # Check prerequisites
  if ! check_prerequisites; then
    return 2
  fi

  # Check configuration
  if ! check_markdown_config; then
    return 2
  fi

  # Check version and performance
  check_markdown_version
  check_performance

  # Run markdown validation
  if ! validate_all_markdown; then
    validation_failed=1
  fi

  # Calculate execution time
  local end_time
  end_time=$(date +%s)
  local duration=$((end_time - start_time))

  # Summary
  if [[ $validation_failed -eq 1 ]]; then
    log_error "Markdown validation failed with $FILES_WITH_ERRORS file(s) having errors"
    if [[ $WARNINGS -gt 0 ]]; then
      log_warning "Total warnings: $WARNINGS"
    fi
    if [[ $FIX_MODE -eq 1 ]]; then
      log_info "Some issues may have been fixed. Run validation again to verify."
    fi
    log_info "Markdown validation completed in ${duration}s"
    return 1
  else
    log_success "Markdown validation passed (${duration}s)"
    if [[ $WARNINGS -gt 0 ]]; then
      log_warning "Total warnings: $WARNINGS"
    fi
    return 0
  fi
}

# Run main function
main
