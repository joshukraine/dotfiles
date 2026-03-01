# Claude Code Permission Presets

Reusable permission configurations for Claude Code projects.

## Architecture

**Default permissions are global.** The base permissions (Unix tools, git, gh, file editing, WebSearch, Context7) live in the global `~/.claude/settings.json` and apply to every project automatically. The presets in this directory provide framework-specific overlays that add tools and domains on top of the global baseline.

## Presets

| File | Purpose |
| --- | --- |
| `default-permissions.json` | Reference copy of the global baseline (kept for `merge-presets` compatibility) |
| `sprint-permissions.json` | All-inclusive standalone preset for housekeeping sprints (base + all overlays) |
| `rails-overlay.json` | Ruby on Rails additive overlay (Ruby, Bundler, binstubs, Rails docs) |
| `hugo-overlay.json` | Hugo additive overlay (Hugo CLI, Node/npm, Hugo docs) |
| `js-overlay.json` | JavaScript/Node.js overlay (Node, npm/yarn/pnpm, TypeScript, ESLint, Vue/Nuxt docs) |
| `dotfiles-overlay.json` | Dotfiles repo overlay (Stow, Lua, Bats, ShellCheck, Neovim docs) |

## Usage

### Quick apply (recommended)

```bash
cc-rails      # Rails overlay → .claude/settings.json
cc-hugo       # Hugo overlay → .claude/settings.json
cc-js         # JS/Node overlay → .claude/settings.json
cc-dotfiles   # dotfiles overlay → .claude/settings.json
cc-sprint     # all overlays combined → .claude/settings.json
cc-default    # info only (default permissions are now global)
cc-clean      # remove .claude/settings.json
cc-perms      # show active permission counts
```

**Note:** `.claude/settings.local.json` may also exist for ad-hoc permission grants (e.g., from "always allow" prompts in Claude Code). It is not created or removed by these commands and takes precedence over `.claude/settings.json`.

### Custom combinations

```bash
cc-apply default-permissions.json rails-overlay.json
cc-apply default-permissions.json hugo-overlay.json dotfiles-overlay.json
```

### Manual

```bash
merge-presets default-permissions.json rails-overlay.json > .claude/settings.json
```

## Design

**Global baseline.** The global `~/.claude/settings.json` provides default allow/deny permissions for all projects. Overlays only need framework-specific additions — git, gh, shell tools, and common web domains are always available.

**Overlays are additive.** Each overlay adds framework-specific tools and documentation domains. The `merge-presets` script combines and deduplicates them. Duplicate entries (from overlays that include default items) are harmless.

**Sprint is standalone.** `sprint-permissions.json` is the union of all overlay-specific permissions (no default entries since those are global). It's designed to be copied directly rather than merged.

**Deny rules stack.** Both global and overlay deny rules are preserved during merge. The global blocks `rm -rf`, `git clean`, `git reset --hard`, and dangerous piped commands. The Rails overlay adds `db:drop` and `db:reset` protection.
