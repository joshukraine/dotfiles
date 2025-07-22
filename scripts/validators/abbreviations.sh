#!/bin/bash
#
# Abbreviation Consistency Validator
#
# Validates abbreviation configuration for consistency and integrity:
# - YAML syntax validation
# - Generated file consistency with source
# - Cross-shell compatibility verification
# - Duplicate abbreviation detection
#
# Exit codes:
#   0 - All abbreviation validation passed
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
YAML_FILE="$DOTFILES_ROOT/shared/abbreviations.yaml"
FISH_ABBR_FILE="$DOTFILES_ROOT/fish/.config/fish/abbreviations.fish"
ZSH_ABBR_FILE="$DOTFILES_ROOT/zsh/.config/zsh-abbr/abbreviations.zsh"
GENERATOR_DIR="$DOTFILES_ROOT/shared"

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
    echo "ABBREVIATIONS_SUCCESS: $1" >&2
  fi
}

log_warning() {
  if [[ $CI_MODE -eq 0 ]]; then
    echo "  ⚠ $1" >&2
  else
    echo "ABBREVIATIONS_WARNING: $1" >&2
  fi
  ((WARNINGS++))
}

log_error() {
  if [[ $CI_MODE -eq 0 ]]; then
    echo "  ✗ $1" >&2
  else
    echo "ABBREVIATIONS_ERROR: $1" >&2
  fi
  ((VALIDATION_ERRORS++))
}

# Check if required tools are available
check_prerequisites() {
  local missing_tools=()
  
  # Check for yq (YAML processor)
  if ! command -v yq >/dev/null 2>&1; then
    missing_tools+=("yq")
  fi
  
  if [[ ${#missing_tools[@]} -gt 0 ]]; then
    log_error "Missing required tools: ${missing_tools[*]}"
    log_error "Install with: brew install ${missing_tools[*]}"
    return 1
  fi
  
  return 0
}

# Validate YAML syntax and structure
validate_yaml_syntax() {
  log_info "Validating YAML syntax and structure..."
  
  if [[ ! -f "$YAML_FILE" ]]; then
    log_error "YAML source file not found: $YAML_FILE"
    return 1
  fi
  
  # Check YAML syntax
  if ! yq eval '.' "$YAML_FILE" >/dev/null 2>&1; then
    log_error "YAML syntax error in: $YAML_FILE"
    if [[ $VERBOSE -eq 1 ]]; then
      echo "    Error details:"
      yq eval '.' "$YAML_FILE" 2>&1 | sed 's/^/      /' >&2 || true
    fi
    return 1
  fi
  
  log_success "YAML syntax is valid"
  
  # Check basic structure
  local categories
  categories=$(yq eval '. | keys' "$YAML_FILE" 2>/dev/null || echo "[]")
  
  if [[ "$categories" == "[]" ]]; then
    log_error "YAML file has no categories defined"
    return 1
  fi
  
  # Count total abbreviations across all categories
  local total_abbr
  total_abbr=$(yq eval '. as $root | [keys[] as $category | $root[$category] | keys[]] | length' "$YAML_FILE" 2>/dev/null || echo "0")
  
  if [[ "$total_abbr" -eq 0 ]]; then
    log_error "No abbreviations found in YAML file"
    return 1
  fi
  
  log_success "YAML structure valid with $total_abbr abbreviations"
  return 0
}

# Check that generated files exist and are newer than source
validate_generated_files() {
  log_info "Validating generated abbreviation files..."
  
  local files_missing=()
  local files_outdated=()
  
  # Check Fish abbreviations file
  if [[ ! -f "$FISH_ABBR_FILE" ]]; then
    files_missing+=("fish/.config/fish/abbreviations.fish")
  elif [[ "$FISH_ABBR_FILE" -ot "$YAML_FILE" ]]; then
    files_outdated+=("fish/.config/fish/abbreviations.fish")
  fi
  
  # Check Zsh abbreviations file
  if [[ ! -f "$ZSH_ABBR_FILE" ]]; then
    files_missing+=("zsh/.config/zsh-abbr/abbreviations.zsh")
  elif [[ "$ZSH_ABBR_FILE" -ot "$YAML_FILE" ]]; then
    files_outdated+=("zsh/.config/zsh-abbr/abbreviations.zsh")
  fi
  
  # Report missing files
  if [[ ${#files_missing[@]} -gt 0 ]]; then
    for file in "${files_missing[@]}"; do
      log_error "Generated file missing: $file"
    done
    
    if [[ $FIX_MODE -eq 1 ]]; then
      log_info "Fixing: Regenerating missing abbreviation files..."
      if regenerate_abbreviations; then
        log_success "Fixed: Generated all abbreviation files"
      else
        log_error "Failed to regenerate abbreviation files"
        return 1
      fi
    else
      log_error "Run 'bash shared/generate-all-abbr.sh' to generate missing files"
      return 1
    fi
  fi
  
  # Report outdated files
  if [[ ${#files_outdated[@]} -gt 0 ]]; then
    for file in "${files_outdated[@]}"; do
      log_warning "Generated file outdated: $file"
    done
    
    if [[ $FIX_MODE -eq 1 ]]; then
      log_info "Fixing: Regenerating outdated abbreviation files..."
      if regenerate_abbreviations; then
        log_success "Fixed: Updated all abbreviation files"
      else
        log_error "Failed to regenerate abbreviation files"
        return 1
      fi
    else
      log_warning "Run 'bash shared/generate-all-abbr.sh' to update files"
    fi
  fi
  
  if [[ ${#files_missing[@]} -eq 0 && ${#files_outdated[@]} -eq 0 ]]; then
    log_success "Generated files are present and up-to-date"
  fi
  
  return 0
}

# Regenerate abbreviation files using existing generators
regenerate_abbreviations() {
  cd "$GENERATOR_DIR"
  
  # Run the main generator script
  if [[ -x "./generate-all-abbr.sh" ]]; then
    ./generate-all-abbr.sh >/dev/null 2>&1
  else
    # Fallback to individual generators
    if [[ -x "./generate-fish-abbr.sh" ]]; then
      ./generate-fish-abbr.sh >/dev/null 2>&1
    fi
    if [[ -x "./generate-zsh-abbr.sh" ]]; then
      ./generate-zsh-abbr.sh >/dev/null 2>&1
    fi
  fi
}

# Validate consistency between YAML source and generated files
validate_generation_consistency() {
  log_info "Validating generation consistency..."
  
  # Check that generated files haven't been manually edited
  if [[ -f "$FISH_ABBR_FILE" ]]; then
    if ! grep -q "DO NOT EDIT THIS FILE DIRECTLY" "$FISH_ABBR_FILE" 2>/dev/null; then
      log_warning "Fish abbreviations file missing 'DO NOT EDIT' warning"
    fi
    
    if ! grep -q "Generated from shared/abbreviations.yaml" "$FISH_ABBR_FILE" 2>/dev/null; then
      log_warning "Fish abbreviations file missing generation source comment"
    fi
  fi
  
  if [[ -f "$ZSH_ABBR_FILE" ]]; then
    if ! grep -q "DO NOT EDIT THIS FILE DIRECTLY" "$ZSH_ABBR_FILE" 2>/dev/null; then
      log_warning "Zsh abbreviations file missing 'DO NOT EDIT' warning"
    fi
    
    if ! grep -q "Generated from shared/abbreviations.yaml" "$ZSH_ABBR_FILE" 2>/dev/null; then
      log_warning "Zsh abbreviations file missing generation source comment"
    fi
  fi
  
  # Count abbreviations in each file for consistency check
  local yaml_count
  yaml_count=$(yq eval '. as $root | [keys[] as $category | $root[$category] | keys[]] | length' "$YAML_FILE" 2>/dev/null || echo "0")
  
  local fish_count
  fish_count=$(grep -c "^abbr -a -g" "$FISH_ABBR_FILE" 2>/dev/null || echo "0")
  
  local zsh_count
  zsh_count=$(grep -c "^abbr \"" "$ZSH_ABBR_FILE" 2>/dev/null || echo "0")
  
  log_info "Abbreviation counts - YAML: $yaml_count, Fish: $fish_count, Zsh: $zsh_count"
  
  # Allow for small differences due to shell-specific abbreviations
  local max_diff=5
  if [[ $((yaml_count - fish_count)) -gt $max_diff ]] || [[ $((fish_count - yaml_count)) -gt $max_diff ]]; then
    log_error "Fish abbreviation count differs significantly from YAML source ($fish_count vs $yaml_count)"
  fi
  
  if [[ $((yaml_count - zsh_count)) -gt $max_diff ]] || [[ $((zsh_count - yaml_count)) -gt $max_diff ]]; then
    log_error "Zsh abbreviation count differs significantly from YAML source ($zsh_count vs $yaml_count)"
  fi
  
  # Detailed consistency check: verify specific abbreviations exist
  local sample_checks=("c" "ga" "gst" "ls")
  for abbr in "${sample_checks[@]}"; do
    # Check if abbreviation exists in any YAML category
    if yq eval ".[] | has(\"$abbr\")" "$YAML_FILE" 2>/dev/null | grep -q "true"; then
      # Verify it exists in Fish file
      if [[ -f "$FISH_ABBR_FILE" ]] && ! grep -q "abbr -a -g $abbr " "$FISH_ABBR_FILE" 2>/dev/null; then
        log_error "Abbreviation '$abbr' missing from Fish generated file"
      fi
      
      # Verify it exists in Zsh file
      if [[ -f "$ZSH_ABBR_FILE" ]] && ! grep -q "abbr \"$abbr\"=" "$ZSH_ABBR_FILE" 2>/dev/null; then
        log_error "Abbreviation '$abbr' missing from Zsh generated file"
      fi
    fi
  done
  
  if [[ $VALIDATION_ERRORS -eq 0 ]]; then
    log_success "Generation consistency validated"
  fi
  
  return 0
}

# Check for duplicate abbreviations within the YAML file
validate_duplicates() {
  log_info "Checking for duplicate abbreviations..."
  
  # Extract all abbreviation keys and check for duplicates
  local all_keys
  all_keys=$(yq eval '. as $root | [keys[] as $category | $root[$category] | keys[]]' "$YAML_FILE" 2>/dev/null || echo "[]")
  
  if [[ "$all_keys" == "[]" ]]; then
    log_error "Could not extract abbreviation keys from YAML"
    return 1
  fi
  
  # Find duplicates by comparing sorted list
  local duplicates
  duplicates=$(echo "$all_keys" | yq eval '.[] | select(. != null)' - 2>/dev/null | sort | uniq -d || echo "")
  
  if [[ -n "$duplicates" ]]; then
    log_error "Duplicate abbreviations found:"
    echo "$duplicates" | while read -r dup; do
      if [[ -n "$dup" ]]; then
        log_error "  - Duplicate key: $dup"
      fi
    done
    return 1
  else
    log_success "No duplicate abbreviations found"
  fi
  
  return 0
}

# Check for potential conflicts with system commands
validate_system_conflicts() {
  log_info "Checking for potential system command conflicts..."
  
  local common_commands=("ls" "cat" "cp" "mv" "rm" "cd" "pwd" "grep" "find" "ps")
  local conflicts=0
  
  for cmd in "${common_commands[@]}"; do
    # Check if command exists as abbreviation in any category
    local abbreviation_value
    abbreviation_value=$(yq eval ".[] | select(has(\"$cmd\")) | .\"$cmd\"" "$YAML_FILE" 2>/dev/null | head -1 || echo "")
    
    if [[ -n "$abbreviation_value" && "$abbreviation_value" != "null" && "$abbreviation_value" != "$cmd" ]]; then
      log_warning "Abbreviation '$cmd' overrides system command with: $abbreviation_value"
      ((conflicts++))
    fi
  done
  
  if [[ $conflicts -eq 0 ]]; then
    log_success "No concerning system command conflicts found"
  else
    log_warning "Found $conflicts potential system command conflicts"
  fi
  
  return 0
}

# Validate generator scripts are executable and functional
validate_generators() {
  log_info "Validating abbreviation generators..."
  
  local generators=(
    "$GENERATOR_DIR/generate-fish-abbr.sh"
    "$GENERATOR_DIR/generate-zsh-abbr.sh"
    "$GENERATOR_DIR/generate-all-abbr.sh"
  )
  
  local generator_errors=0
  
  for generator in "${generators[@]}"; do
    local relative_generator="${generator#"$DOTFILES_ROOT"/}"
    
    if [[ ! -f "$generator" ]]; then
      log_error "Generator script not found: $relative_generator"
      ((generator_errors++))
      continue
    fi
    
    if [[ ! -x "$generator" ]]; then
      log_error "Generator script not executable: $relative_generator"
      ((generator_errors++))
      
      if [[ $FIX_MODE -eq 1 ]]; then
        log_info "Fixing: Making $relative_generator executable"
        chmod +x "$generator"
        log_success "Fixed: $relative_generator is now executable"
      fi
    else
      log_success "Generator executable: $relative_generator"
    fi
  done
  
  if [[ $generator_errors -gt 0 ]]; then
    log_error "Found $generator_errors generator script error(s)"
    return 1
  fi
  
  return 0
}

# Main validation function
main() {
  local validation_failed=0
  
  # Change to dotfiles root
  cd "$DOTFILES_ROOT"
  
  # Check prerequisites
  if ! check_prerequisites; then
    return 2
  fi
  
  # Run all abbreviation validations
  if ! validate_yaml_syntax; then
    validation_failed=1
  fi
  
  if ! validate_generated_files; then
    validation_failed=1
  fi
  
  if ! validate_generation_consistency; then
    validation_failed=1
  fi
  
  if ! validate_duplicates; then
    validation_failed=1
  fi
  
  if ! validate_system_conflicts; then
    validation_failed=1
  fi
  
  if ! validate_generators; then
    validation_failed=1
  fi
  
  # Summary
  if [[ $validation_failed -eq 1 ]]; then
    log_error "Abbreviation validation failed with $VALIDATION_ERRORS error(s)"
    if [[ $WARNINGS -gt 0 ]]; then
      log_warning "Total warnings: $WARNINGS"
    fi
    return 1
  else
    log_success "Abbreviation validation passed"
    if [[ $WARNINGS -gt 0 ]]; then
      log_warning "Total warnings: $WARNINGS"
    fi
    return 0
  fi
}

# Run main function
main