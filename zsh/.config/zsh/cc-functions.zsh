# Claude Code preset management
# Add these to your .zshrc or a sourced file like .zshrc.local

# Apply merged presets to the current project
# Usage: cc-apply default-permissions.json rails-overlay.json
cc-apply() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: cc-apply <preset.json> [overlay.json ...]"
    echo "Available presets:"
    find ~/.claude/presets -maxdepth 1 -name '*.json' -exec basename {} \;
    return 1
  fi

  mkdir -p .claude
  merge-presets "$@" > .claude/settings.local.json
  echo "Applied permissions to .claude/settings.local.json"
}

# Quick preset aliases
cc-rails() {
  cc-apply default-permissions.json rails-overlay.json
}

cc-hugo() {
  cc-apply default-permissions.json hugo-overlay.json
}

cc-dotfiles() {
  cc-apply default-permissions.json dotfiles-overlay.json
}

cc-sprint() {
  cp ~/.claude/presets/sprint-permissions.json .claude/settings.local.json
  echo "Sprint permissions applied"
}

cc-default() {
  cp ~/.claude/presets/default-permissions.json .claude/settings.local.json
  echo "Default permissions applied"
}

# Remove local permissions (revert to project baseline)
cc-clean() {
  rm -f .claude/settings.local.json
  echo "Local permissions removed"
}

# Show what's currently active
cc-perms() {
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
