# Claude Code Permission Presets

Reusable permission configurations for Claude Code projects.

## Architecture

**Self-contained project files.** Each `cc-*` command produces a complete `.claude/settings.json` by merging `default-permissions.json` (base) with a framework-specific overlay. This ensures every project has the full permission set regardless of how Claude Code resolves global vs. project settings (see [Issue #17017](https://github.com/anthropics/claude-code/issues/17017)).

## Presets

| File | Purpose |
| --- | --- |
| `default-permissions.json` | Base permissions: Unix tools, git, gh, file editing, WebSearch, Context7, and the full deny list |
| `sprint-permissions.json` | All-inclusive standalone preset for housekeeping sprints (base + all overlays) |
| `rails-overlay.json` | Ruby on Rails additive overlay (Ruby, Bundler, binstubs, Rails docs) |
| `hugo-overlay.json` | Hugo additive overlay (Hugo CLI, Node/npm, Hugo docs) |
| `js-overlay.json` | JavaScript/Node.js overlay (Node, npm/yarn/pnpm, TypeScript, ESLint, Vue/Nuxt docs) |
| `dotfiles-overlay.json` | Dotfiles repo overlay (Stow, Lua, Bats, ShellCheck, Neovim docs) |

## Usage

### Quick apply (recommended)

```bash
cc-default    # base permissions only → .claude/settings.json
cc-rails      # base + Rails overlay → .claude/settings.json
cc-hugo       # base + Hugo overlay → .claude/settings.json
cc-js         # base + JS/Node overlay → .claude/settings.json
cc-dotfiles   # base + dotfiles overlay → .claude/settings.json
cc-sprint     # base + all overlays combined → .claude/settings.json
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

**Base + overlay merge.** Every `cc-*` command merges `default-permissions.json` with the relevant overlay(s), producing a self-contained project file. This avoids depending on global permission inheritance, which is unreliable per Issue #17017.

**Overlays are additive.** Each overlay adds framework-specific tools and documentation domains. The `merge-presets` script combines and deduplicates them. Duplicate entries (from overlays that include items also in the base) are harmless.

**Sprint is standalone.** `sprint-permissions.json` is the union of base permissions and all overlay-specific permissions. It's designed to be copied directly rather than merged.

**Deny rules stack.** Both base and overlay deny rules are preserved during merge. The base blocks `rm -rf`, `git clean`, `git reset --hard`, `sudo`, dangerous piped commands, and sensitive file access. The Rails overlay adds `db:drop` and `db:reset` protection.
