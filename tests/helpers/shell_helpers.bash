#!/usr/bin/env bash

# Shell environment test helpers for dotfiles testing framework

# Load DOTFILES variable with shell-agnostic fallback logic
load_dotfiles_variable() {

  # Method 1: Check if DOTFILES is already set (e.g., from parent shell)
  if [ -n "${DOTFILES}" ] && [ -d "${DOTFILES}" ] && [ -f "${DOTFILES}/setup.sh" ]; then
    return 0
  fi

  # Method 2: CI environment detection - use GITHUB_WORKSPACE
  if [ -n "${GITHUB_WORKSPACE}" ] && [ -d "${GITHUB_WORKSPACE}" ] && [ -f "${GITHUB_WORKSPACE}/setup.sh" ]; then
    export DOTFILES="${GITHUB_WORKSPACE}"
    return 0
  fi

  # Method 3: Source bash environment file
  if [ -f "${HOME}/dotfiles/shared/environment.sh" ]; then
    source "${HOME}/dotfiles/shared/environment.sh"
    if [ -n "${DOTFILES}" ] && [ -d "${DOTFILES}" ] && [ -f "${DOTFILES}/setup.sh" ]; then
      return 0
    fi
  fi

  # Method 4: Fallback to conventional location
  if [ -d "${HOME}/dotfiles" ] && [ -f "${HOME}/dotfiles/setup.sh" ]; then
    export DOTFILES="${HOME}/dotfiles"
    return 0
  fi

  # Method 5: Check current working directory (for tests run from dotfiles root)
  if [ -f "./setup.sh" ] && [ -d "./shared" ]; then
    DOTFILES="$(pwd)"
    export DOTFILES
    return 0
  fi

  echo "Error: Cannot determine DOTFILES location" >&2
  return 1
}

# Load the DOTFILES variable
if ! load_dotfiles_variable; then
  echo "Failed to load DOTFILES environment variable" >&2
  exit 1
fi

# Load Zsh functions for testing
load_zsh_functions() {
  local zsh_functions_file="${DOTFILES}/zsh/.config/zsh/functions.zsh"

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

  test_zsh_abbreviation "${abbr}" "${expected}"
}

# Test Zsh abbreviation expansion
test_zsh_abbreviation() {
  local abbr="$1"
  local expected="$2"

  # Load Zsh abbreviations file
  local zsh_abbr_file="${DOTFILES}/zsh/.config/zsh-abbr/abbreviations.zsh"

  if [ -f "${zsh_abbr_file}" ]; then
    # Extract the abbreviation expansion from the Zsh file
    # Format: abbr "abbr_name"="expansion"
    local actual
    actual=$(grep -F "abbr \"${abbr}\"=" "${zsh_abbr_file}" | cut -d'"' -f4 2>/dev/null)

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
  local env_file="${DOTFILES}/shared/environment.sh"

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
  export PATH="${DOTFILES}/bin/.local/bin:${PATH}"
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
      tmp-* | test-* | *test* | custom-session | My_Custom-Session_Name)
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
  cat >"${MOCK_TMUX_PATH}" <<'EOF'
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
