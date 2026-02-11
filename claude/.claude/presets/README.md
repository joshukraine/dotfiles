# Claude Code Permission Presets

Reusable permission configurations for Claude Code projects.

## Presets

| File | Purpose |
| --- | --- |
| `default-permissions.json` | Base permissions for any project (Unix tools, git, gh, file editing) |
| `sprint-permissions.json` | All-inclusive preset for housekeeping sprints (base + all frameworks) |
| `rails-overlay.json` | Ruby on Rails additive overlay (Ruby, Bundler, binstubs, Rails docs) |
| `hugo-overlay.json` | Hugo additive overlay (Hugo CLI, Node/npm, Hugo docs) |
| `dotfiles-overlay.json` | Dotfiles repo overlay (Stow, Lua, Bats, ShellCheck, Neovim docs) |

## Usage

### Quick apply (recommended)

```bash
cc-rails      # default + Rails → .claude/settings.local.json
cc-hugo       # default + Hugo → .claude/settings.local.json
cc-dotfiles   # default + dotfiles → .claude/settings.local.json
cc-sprint     # full sprint preset → .claude/settings.local.json
cc-default    # base only → .claude/settings.local.json
cc-clean      # remove .claude/settings.local.json
cc-perms      # show active permission counts
```

### Custom combinations

```bash
cc-apply default-permissions.json rails-overlay.json
cc-apply default-permissions.json hugo-overlay.json dotfiles-overlay.json
```

### Manual

```bash
merge-presets default-permissions.json rails-overlay.json > .claude/settings.local.json
```

## Design

**Overlays are additive.** The base preset covers universally safe operations.
Each overlay adds framework-specific tools and documentation domains. The
`merge-presets` script combines and deduplicates them.

**Sprint is standalone.** Unlike the overlays, `sprint-permissions.json` is a
self-contained superset that includes the base plus all framework tooling.
It's designed to be copied directly rather than merged.

**Deny rules stack.** Both base and overlay deny rules are preserved during
merge. The base blocks `rm -rf`, force push, and hard reset. The Rails
overlay adds `db:drop` and `db:reset` protection.
