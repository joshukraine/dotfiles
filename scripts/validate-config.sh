#!/bin/bash
#
# Configuration Validation Runner
#
# Validates dotfiles configurations for syntax, consistency, and integrity
# across both Fish and Zsh environments.
#
# Usage:
#   ./validate-config.sh [options]
#
# Options:
#   --help           Show this help message
#   --fix            Attempt to fix issues automatically
#   --report         Generate detailed validation report
#   --validator NAME Run specific validator only
#   --quiet          Suppress verbose output
#   --ci             CI mode (machine-readable output)
#
# Exit codes:
#   0 - All validations passed
#   1 - Validation failures found
#   2 - Script error or invalid usage

set -euo pipefail

# Script directory and dotfiles root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
VALIDATORS_DIR="${SCRIPT_DIR}/validators"

# Configuration
VERBOSE=1
FIX_MODE=0
REPORT_MODE=0
CI_MODE=0
SPECIFIC_VALIDATOR=""
VALIDATION_ERRORS=0

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
  if [[ ${VERBOSE} -eq 1 && ${CI_MODE} -eq 0 ]]; then
    echo -e "${BLUE}ℹ${NC} $1" >&2
  fi
}

log_success() {
  if [[ ${CI_MODE} -eq 0 ]]; then
    echo -e "${GREEN}✓${NC} $1" >&2
  else
    echo "SUCCESS: $1" >&2
  fi
}

log_warning() {
  if [[ ${CI_MODE} -eq 0 ]]; then
    echo -e "${YELLOW}⚠${NC} $1" >&2
  else
    echo "WARNING: $1" >&2
  fi
}

log_error() {
  if [[ ${CI_MODE} -eq 0 ]]; then
    echo -e "${RED}✗${NC} $1" >&2
  else
    echo "ERROR: $1" >&2
  fi
}

# Get available validators with descriptions
get_available_validators() {
  # Define validator descriptions
  case "${1:-}" in
    shell-syntax) echo "shell-syntax:Validate shell syntax (Fish, Zsh, Bash)" ;;
    abbreviations) echo "abbreviations:Validate abbreviation consistency" ;;
    environment) echo "environment:Validate environment variables" ;;
    dependencies) echo "dependencies:Validate required dependencies" ;;
    markdown) echo "markdown:Validate markdown formatting" ;;
    *)
      # Return all validators
      for validator_file in "${VALIDATORS_DIR}"/*.sh; do
        if [[ -f "${validator_file}" ]]; then
          local validator_name
          validator_name="$(basename "${validator_file}" .sh)"
          get_available_validators "${validator_name}"
        fi
      done
      ;;
  esac
}

# Show available validators
show_validators() {
  echo "Available Validators:"
  echo

  local validators
  while IFS= read -r line; do
    if [[ -n "${line}" ]]; then
      local name="${line%%:*}"
      local desc="${line#*:}"
      printf "    %-16s %s\n" "${name}" "${desc}"
    fi
  done < <(get_available_validators | sort)
}

# Show usage information
show_usage() {
  cat << EOF
Configuration Validation Runner

Validates dotfiles configurations for syntax, consistency, and integrity
across both Fish and Zsh environments.

USAGE:
    ./validate-config.sh [OPTIONS]

OPTIONS:
    -h, --help              Show this help message
    -l, --list-validators   List all available validators
    -f, --fix               Attempt to fix issues automatically
    -r, --report            Generate detailed validation report
    -v, --validator NAME    Run specific validator only
    -q, --quiet             Suppress verbose output
    -c, --ci                CI mode (machine-readable output)

EOF

  show_validators

  cat << EOF

EXIT CODES:
    0                       All validations passed
    1                       Validation failures found
    2                       Script error or invalid usage

EXAMPLES:
    ./validate-config.sh                    # Run all validators
    ./validate-config.sh --fix              # Run with auto-fix mode
    ./validate-config.sh -v markdown        # Run only markdown validator
    ./validate-config.sh --list-validators  # Show available validators
    ./validate-config.sh --ci               # CI-friendly output
EOF
}

# Parse command line arguments
parse_args() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      -h | --help)
        show_usage
        exit 0
        ;;
      -l | --list-validators)
        show_validators
        exit 0
        ;;
      -f | --fix)
        FIX_MODE=1
        shift
        ;;
      -r | --report)
        REPORT_MODE=1
        shift
        ;;
      -v | --validator)
        SPECIFIC_VALIDATOR="$2"
        shift 2
        ;;
      -q | --quiet)
        VERBOSE=0
        shift
        ;;
      -c | --ci)
        CI_MODE=1
        VERBOSE=0
        shift
        ;;
      *)
        log_error "Unknown option: $1"
        show_usage >&2
        exit 2
        ;;
    esac
  done
}

# Check if validator exists and is executable
validate_validator() {
  local validator_name="$1"
  local validator_path="${VALIDATORS_DIR}/${validator_name}.sh"

  if [[ ! -f "${validator_path}" ]]; then
    log_error "Validator not found: ${validator_name}"
    return 1
  fi

  if [[ ! -x "${validator_path}" ]]; then
    log_error "Validator not executable: ${validator_name}"
    return 1
  fi

  return 0
}

# Run a specific validator
run_validator() {
  local validator_name="$1"
  local validator_path="${VALIDATORS_DIR}/${validator_name}.sh"

  log_info "Running validator: ${validator_name}"

  # Set up environment for validator
  export DOTFILES_ROOT
  export FIX_MODE
  export REPORT_MODE
  export CI_MODE
  export VERBOSE

  # Run the validator and capture exit code
  local exit_code=0
  "${validator_path}"
  exit_code=$?

  if [[ ${exit_code} -eq 0 ]]; then
    log_success "Validation passed: ${validator_name}"
  elif [[ ${exit_code} -eq 1 ]]; then
    log_error "Validation failed: ${validator_name}"
    ((VALIDATION_ERRORS++))
  elif [[ ${exit_code} -eq 2 ]]; then
    log_error "Validator error: ${validator_name}"
    return 2
  else
    log_error "Validator returned unexpected exit code ${exit_code}: ${validator_name}"
    ((VALIDATION_ERRORS++))
  fi

  return 0
}

# Get list of available validators
get_validators() {
  if [[ -n "${SPECIFIC_VALIDATOR}" ]]; then
    echo "${SPECIFIC_VALIDATOR}"
    return
  fi

  # List all .sh files in validators directory, ordered by priority
  local priority_validators=(
    "shell-syntax"
    "abbreviations"
    "environment"
    "dependencies"
    "markdown"
  )

  # First run priority validators in order
  for validator in "${priority_validators[@]}"; do
    if [[ -f "${VALIDATORS_DIR}/${validator}.sh" ]]; then
      echo "${validator}"
    fi
  done

  # Then run any remaining validators
  for validator_file in "${VALIDATORS_DIR}"/*.sh; do
    if [[ -f "${validator_file}" ]]; then
      local validator_name
      validator_name="$(basename "${validator_file}" .sh)"

      # Skip if already in priority list
      local skip=0
      for priority_validator in "${priority_validators[@]}"; do
        if [[ "${validator_name}" == "${priority_validator}" ]]; then
          skip=1
          break
        fi
      done

      if [[ ${skip} -eq 0 ]]; then
        echo "${validator_name}"
      fi
    fi
  done
}

# Main validation function
main() {
  local start_time
  start_time=$(date +%s)

  # Change to dotfiles root directory
  cd "${DOTFILES_ROOT}"

  # Validate environment
  if [[ ! -d "${VALIDATORS_DIR}" ]]; then
    log_error "Validators directory not found: ${VALIDATORS_DIR}"
    exit 2
  fi

  # Check for specific validator if requested
  if [[ -n "${SPECIFIC_VALIDATOR}" ]]; then
    if ! validate_validator "${SPECIFIC_VALIDATOR}"; then
      exit 2
    fi
  fi

  # Get list of validators to run
  local validators=()
  while IFS= read -r validator; do
    validators+=("${validator}")
  done < <(get_validators)

  if [[ ${#validators[@]} -eq 0 ]]; then
    log_error "No validators found"
    exit 2
  fi

  log_info "Starting configuration validation..."
  log_info "Dotfiles root: ${DOTFILES_ROOT}"
  if [[ ${FIX_MODE} -eq 1 ]]; then
    log_info "Fix mode: enabled"
  fi
  if [[ ${REPORT_MODE} -eq 1 ]]; then
    log_info "Report mode: enabled"
  fi

  # Run all validators
  local validator_count=0
  for validator in "${validators[@]}"; do
    ((validator_count++))

    if [[ ${VERBOSE} -eq 1 ]]; then
      echo
      log_info "[${validator_count}/${#validators[@]}] Validator: ${validator}"
    fi

    if ! run_validator "${validator}"; then
      log_error "Validator execution failed: ${validator}"
      exit 2
    fi
  done

  # Calculate execution time
  local end_time
  end_time=$(date +%s)
  local duration=$((end_time - start_time))

  # Summary
  echo
  if [[ ${VALIDATION_ERRORS} -eq 0 ]]; then
    log_success "All validations passed! (${duration}s)"
    if [[ ${duration} -gt 30 ]]; then
      log_warning "Validation took longer than 30s target: ${duration}s"
    fi
    exit 0
  else
    log_error "Validation failed with ${VALIDATION_ERRORS} error(s) (${duration}s)"
    if [[ ${FIX_MODE} -eq 1 ]]; then
      log_info "Some issues may have been automatically fixed. Please review changes."
    fi
    exit 1
  fi
}

# Parse arguments and run main function
parse_args "$@"
main
