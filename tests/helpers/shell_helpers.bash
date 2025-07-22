#!/usr/bin/env bash

# Shell environment test helpers for dotfiles testing framework

# Source dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Load Fish functions for testing
load_fish_function() {
  local function_name="$1"
  local fish_function_file="${DOTFILES_DIR}/fish/.config/fish/functions/${function_name}.fish"

  if [ -f "${fish_function_file}" ]; then
    # Convert Fish function syntax to bash-compatible for testing
    # This is a simplified approach - we'll execute fish commands via fish shell
    export FISH_FUNCTION_FILE="${fish_function_file}"
    return 0
  else
    return 1
  fi
}

# Execute Fish function in fish shell
run_fish_function() {
  local function_name="$1"
  shift
  local args="$*"

  if load_fish_function "${function_name}"; then
    # Source the fish function and execute it, with minimal config to avoid errors
    # Pass PATH so mocked commands work, and source git-check-uncommitted if it exists
    local git_check_file="${DOTFILES_DIR}/bin/.local/bin/git-check-uncommitted"
    if [ -f "${git_check_file}" ]; then
      env PATH="${PATH}" fish --no-config -c "set -x PATH '${PATH}'; function git-check-uncommitted; '${git_check_file}' \$argv; end; source '${FISH_FUNCTION_FILE}'; ${function_name} ${args}" 2>&1
    else
      env PATH="${PATH}" fish --no-config -c "set -x PATH '${PATH}'; source '${FISH_FUNCTION_FILE}'; ${function_name} ${args}" 2>&1
    fi
  else
    echo "Fish function ${function_name} not found"
    return 1
  fi
}

# Load Zsh functions for testing
load_zsh_functions() {
  local zsh_functions_file="${DOTFILES_DIR}/zsh/.config/zsh/functions.zsh"

  if [ -f "${zsh_functions_file}" ]; then
    # Source the Zsh functions in current bash session
    # We'll need to adapt Zsh syntax to bash where needed
    source "${zsh_functions_file}" 2>/dev/null || true
    return 0
  else
    return 1
  fi
}

# Execute Zsh function
run_zsh_function() {
  local function_name="$1"
  shift
  local args="$*"

  if load_zsh_functions; then
    # Execute the function if it's available
    if command -v "${function_name}" >/dev/null 2>&1; then
      "${function_name}" "$@" 2>&1
    else
      echo "Zsh function ${function_name} not found"
      return 1
    fi
  else
    echo "Failed to load Zsh functions"
    return 1
  fi
}

# Test abbreviation expansion
test_abbreviation() {
  local abbr="$1"
  local expected="$2"
  local shell_type="${3:-both}"

  case "${shell_type}" in
    "fish")
      test_fish_abbreviation "${abbr}" "${expected}"
      ;;
    "zsh")
      test_zsh_abbreviation "${abbr}" "${expected}"
      ;;
    "both")
      test_fish_abbreviation "${abbr}" "${expected}" &&
      test_zsh_abbreviation "${abbr}" "${expected}"
      ;;
    *)
      echo "Unknown shell type: ${shell_type}"
      return 1
      ;;
  esac
}

# Test Fish abbreviation expansion
test_fish_abbreviation() {
  local abbr="$1"
  local expected="$2"

  # Load Fish abbreviations file
  local fish_abbr_file="${DOTFILES_DIR}/fish/.config/fish/abbreviations.fish"

  if [ -f "${fish_abbr_file}" ]; then
    # Extract the abbreviation expansion from the Fish file
    # Format: abbr -a -g abbr_name 'expansion'
    local actual
    actual=$(grep "^abbr -a -g ${abbr} " "${fish_abbr_file}" | sed "s/^abbr -a -g ${abbr} '//" | sed "s/'$//" 2>/dev/null)

    if [ "${actual}" = "${expected}" ]; then
      return 0
    else
      echo "Fish abbreviation mismatch: '${abbr}' -> '${actual}' (expected: '${expected}')"
      return 1
    fi
  else
    echo "Fish abbreviations file not found"
    return 1
  fi
}

# Test Zsh abbreviation expansion
test_zsh_abbreviation() {
  local abbr="$1"
  local expected="$2"

  # Load Zsh abbreviations file
  local zsh_abbr_file="${DOTFILES_DIR}/zsh/.config/zsh-abbr/abbreviations.zsh"

  if [ -f "${zsh_abbr_file}" ]; then
    # Extract the abbreviation expansion from the Zsh file
    # Format: abbr "abbr_name"="expansion"
    local actual
    actual=$(grep "^abbr \"${abbr}\"=" "${zsh_abbr_file}" | cut -d'"' -f4 2>/dev/null)

    if [ "${actual}" = "${expected}" ]; then
      return 0
    else
      echo "Zsh abbreviation mismatch: '${abbr}' -> '${actual}' (expected: '${expected}')"
      return 1
    fi
  else
    echo "Zsh abbreviations file not found"
    return 1
  fi
}

# Load environment variables
load_environment() {
  local env_file="${DOTFILES_DIR}/shared/environment.sh"

  if [ -f "${env_file}" ]; then
    source "${env_file}"
    return 0
  else
    return 1
  fi
}

# Test if command exists in PATH
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Test if function is available
function_exists() {
  [ "$(type -t "$1")" = "function" ]
}

# Setup PATH with dotfiles bin directory
setup_dotfiles_path() {
  export PATH="${DOTFILES_DIR}/bin/.local/bin:${PATH}"
}

# Restore original PATH
restore_path() {
  if [ -n "${ORIGINAL_PATH}" ]; then
    export PATH="${ORIGINAL_PATH}"
  fi
}

# Save original PATH
save_original_path() {
  export ORIGINAL_PATH="${PATH}"
}

# Tmux session management for tests
TEST_TMUX_SESSIONS=()

# Track a tmux session for cleanup
track_tmux_session() {
  local session_name="$1"
  TEST_TMUX_SESSIONS+=("${session_name}")
}

# Cleanup all tracked tmux sessions
cleanup_tracked_tmux_sessions() {
  for session in "${TEST_TMUX_SESSIONS[@]}"; do
    tmux kill-session -t "${session}" 2>/dev/null || true
  done
  TEST_TMUX_SESSIONS=()
}

# Cleanup all test-related tmux sessions
cleanup_all_test_tmux_sessions() {
  # Kill sessions that look like test sessions
  tmux list-sessions -F "#{session_name}" 2>/dev/null | while read -r session; do
    case "${session}" in
      tmp-*|test-*|*test*|custom-session|My_Custom-Session_Name)
        tmux kill-session -t "${session}" 2>/dev/null || true
        ;;
    esac
  done
}

# Mock tmux commands to prevent terminal hijacking during tests
setup_tmux_mocking() {
  # Create mock tmux commands that don't actually attach or switch
  export MOCK_TMUX_SESSIONS=""
  export MOCK_TMUX_ACTIVE="true"

  # Create a mock tmux script in a temporary location
  export MOCK_TMUX_DIR
  MOCK_TMUX_DIR=$(mktemp -d)
  export MOCK_TMUX_PATH="${MOCK_TMUX_DIR}/tmux"

  # Create the mock tmux script
  cat > "${MOCK_TMUX_PATH}" << 'EOF'
#!/usr/bin/env bash

case "$1" in
  "new-session")
    # Parse arguments to track session creation
    local session_name=""
    local detached=false
    local attach_existing=false

    while [[ $# -gt 0 ]]; do
      case $1 in
        -s)
          session_name="$2"
          shift 2
          ;;
        -A|-As)
          attach_existing=true
          shift
          ;;
        -d|-Ad)
          detached=true
          shift
          ;;
        *)
          shift
          ;;
      esac
    done

    if [[ -n "$session_name" ]]; then
      # Track the session creation without actually creating it
      if [[ "$MOCK_TMUX_SESSIONS" != *"$session_name"* ]]; then
        export MOCK_TMUX_SESSIONS="$MOCK_TMUX_SESSIONS $session_name"
      fi
      echo "Mock: Created tmux session '$session_name'"
      exit 0
    fi
    ;;
  "switch-client")
    # Parse target session
    local target=""
    if [[ "$2" == "-t" && -n "$3" ]]; then
      target="$3"
    fi
    echo "Mock: Switched to tmux session '$target'"
    exit 0
    ;;
  "list-sessions")
    # Return mock session list for session_exists checks
    if [[ -n "$MOCK_TMUX_SESSIONS" ]]; then
      for session in $MOCK_TMUX_SESSIONS; do
        echo "$session: 1 windows (created $(date))"
      done
    fi
    exit 0
    ;;
  "kill-session")
    # Parse target session for cleanup
    local target=""
    if [[ "$2" == "-t" && -n "$3" ]]; then
      target="$3"
      # Remove from mock sessions - handle edge cases with exact matching
      export MOCK_TMUX_SESSIONS=$(echo "$MOCK_TMUX_SESSIONS" | sed "s/\(^\|  *\)$target\( \|$\)/ /g" | sed 's/^  *//' | sed 's/  *$//')
      echo "Mock: Killed tmux session '$target'"
    fi
    exit 0
    ;;
  *)
    # For other tmux commands, call the real tmux but only if it's safe
    # In CI, we don't want any real tmux commands to run
    if [[ -n "$CI" ]]; then
      echo "Mock: tmux $*"
      exit 0
    else
      command tmux "$@"
    fi
    ;;
esac
EOF

  chmod +x "${MOCK_TMUX_PATH}"

  # Add mock tmux to the front of PATH
  export ORIGINAL_PATH="${PATH}"
  export PATH="${MOCK_TMUX_DIR}:${PATH}"
}

# Restore real tmux command
restore_tmux() {
  # Restore original PATH
  if [[ -n "${ORIGINAL_PATH}" ]]; then
    export PATH="${ORIGINAL_PATH}"
  fi

  # Clean up mock tmux directory
  if [[ -n "${MOCK_TMUX_DIR}" && -d "${MOCK_TMUX_DIR}" ]]; then
    rm -rf "${MOCK_TMUX_DIR}"
  fi

  # Clean up environment variables
  unset MOCK_TMUX_SESSIONS
  unset MOCK_TMUX_ACTIVE
  unset MOCK_TMUX_DIR
  unset MOCK_TMUX_PATH
}
