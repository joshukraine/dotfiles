# Claude Code preset management
# Sourced from .zshrc

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
    cp "${resolved}" .claude/settings.local.json
  else
    # Multiple presets: merge via temp file to avoid truncation on failure
    local tmpfile
    tmpfile=$(mktemp .claude/settings.local.json.tmp.XXXXXX) || {
      echo "Failed to create temporary file" >&2
      return 1
    }

    if merge-presets "$@" > "${tmpfile}"; then
      mv "${tmpfile}" .claude/settings.local.json
    else
      echo "Error: failed to merge presets; permissions not updated" >&2
      rm -f "${tmpfile}"
      return 1
    fi
  fi

  echo "Applied permissions to .claude/settings.local.json"
}

# Quick preset aliases
function cc-rails() {
  cc-apply default-permissions.json rails-overlay.json
}

function cc-hugo() {
  cc-apply default-permissions.json hugo-overlay.json
}

function cc-dotfiles() {
  cc-apply default-permissions.json dotfiles-overlay.json
}

function cc-sprint() {
  mkdir -p .claude
  cp ~/.claude/presets/sprint-permissions.json .claude/settings.local.json
  echo "Sprint permissions applied"
}

function cc-default() {
  mkdir -p .claude
  cp ~/.claude/presets/default-permissions.json .claude/settings.local.json
  echo "Default permissions applied"
}

# Remove local permissions (revert to project baseline)
function cc-clean() {
  rm -f .claude/settings.local.json
  echo "Local permissions removed"
}

# Show what's currently active
function cc-perms() {
  if [[ -f .claude/settings.local.json ]]; then
    echo "=== .claude/settings.local.json ==="
    jq '.permissions | {allow: (.allow | length), deny: (.deny | length)}' .claude/settings.local.json
  else
    echo "No local permissions file found."
  fi

  if [[ -f .claude/settings.json ]]; then
    echo "=== .claude/settings.json ==="
    jq '.permissions | {allow: (.allow | length), deny: (.deny | length)}' .claude/settings.json
  fi
}
