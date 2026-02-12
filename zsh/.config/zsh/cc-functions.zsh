# Claude Code preset management
# Sourced from .zshrc

# Back up target file if it exists and differs from the new source.
# Prevents silent data loss when a preset overwrites customized permissions.
function _cc-backup-if-changed() {
  local target="$1" source="$2"
  if [[ -f "${target}" ]] && ! diff -q "${target}" "${source}" &>/dev/null; then
    cp "${target}" "${target}.bak"
    echo "Backed up existing ${target} → ${target}.bak"
  fi
}

# Apply merged presets to the current project
# Usage: cc-apply default-permissions.json rails-overlay.json
function cc-apply() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: cc-apply <preset.json> [overlay.json ...]"
    echo "Available presets:"
    find ~/.claude/presets -maxdepth 1 -name '*.json' -exec basename {} \;
    return 1
  fi

  mkdir -p .claude

  if [[ $# -eq 1 ]]; then
    # Single preset: copy directly instead of merging
    local resolved="$1"
    if [[ ! -f "${resolved}" && -f "${HOME}/.claude/presets/${resolved}" ]]; then
      resolved="${HOME}/.claude/presets/${resolved}"
    fi
    if [[ ! -f "${resolved}" ]]; then
      echo "Preset not found: $1" >&2
      return 1
    fi
    _cc-backup-if-changed .claude/settings.json "${resolved}"
    cp "${resolved}" .claude/settings.json
  else
    # Multiple presets: merge via temp file to avoid truncation on failure
    local tmpfile
    tmpfile=$(mktemp .claude/settings.json.tmp.XXXXXX) || {
      echo "Failed to create temporary file" >&2
      return 1
    }

    if merge-presets "$@" > "${tmpfile}"; then
      _cc-backup-if-changed .claude/settings.json "${tmpfile}"
      mv "${tmpfile}" .claude/settings.json
    else
      echo "Error: failed to merge presets; permissions not updated" >&2
      rm -f "${tmpfile}"
      return 1
    fi
  fi

  echo "Applied permissions to .claude/settings.json"
}

# Quick preset aliases
function cc-rails() {
  cc-apply default-permissions.json rails-overlay.json
}

function cc-hugo() {
  cc-apply default-permissions.json hugo-overlay.json
}

function cc-js() {
  cc-apply default-permissions.json js-overlay.json
}

function cc-dotfiles() {
  cc-apply default-permissions.json dotfiles-overlay.json
}

function cc-sprint() {
  mkdir -p .claude
  _cc-backup-if-changed .claude/settings.json ~/.claude/presets/sprint-permissions.json
  cp ~/.claude/presets/sprint-permissions.json .claude/settings.json
  echo "Sprint permissions applied"
}

function cc-default() {
  mkdir -p .claude
  _cc-backup-if-changed .claude/settings.json ~/.claude/presets/default-permissions.json
  cp ~/.claude/presets/default-permissions.json .claude/settings.json
  echo "Default permissions applied"
}

# Remove applied permissions
function cc-clean() {
  rm -f .claude/settings.json
  echo "Preset permissions removed (.claude/settings.json)"
  if [[ -f .claude/settings.local.json ]]; then
    echo "Note: .claude/settings.local.json still exists (ad-hoc grants)"
  fi
}

# Show what's currently active
function cc-perms() {
  if [[ -f .claude/settings.json ]]; then
    echo "=== .claude/settings.json (preset) ==="
    jq '.permissions | {allow: (.allow | length), deny: (.deny | length)}' .claude/settings.json
  else
    echo "No preset permissions file found."
  fi

  if [[ -f .claude/settings.local.json ]]; then
    echo "=== .claude/settings.local.json (ad-hoc) ==="
    jq '.permissions | {allow: (.allow | length), deny: (.deny | length)}' .claude/settings.local.json
  fi
}
