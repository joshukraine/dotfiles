# Claude Code Cheatsheet

_Last updated: 2026-06-26_ <!-- Update this date when editing this file -->

Quick reference for usage tips, keyboard shortcuts, and workflow habits.

## Keyboard Shortcuts

| Shortcut | Action |
| ---------- | ------ |
| `Option+T` | Toggle extended thinking on/off for current session |
| `Esc Esc` | Open checkpoint/rewind menu |
| `Shift+Tab` | Cycle permission modes (default → accept-edits → plan → auto) |

## Fullscreen Scrolling

Fullscreen TUI rendering is enabled via `"tui": "fullscreen"` in `settings.json` to fix repaint corruption in the sidekick.nvim nested-tmux stack (Ghostty → tmux → Neovim `:terminal` → nested tmux → Claude). The conversation renders to the terminal's alternate screen buffer, so scrolling happens inside Claude — terminal/tmux scrollback and the mouse wheel don't apply.

| Shortcut | Action |
| -------- | ------ |
| `Ctrl+↑` / `Ctrl+↓` | Scroll one line (custom binding — see below) |
| `PageUp` / `PageDn` | Scroll half a screen |
| `Ctrl+Home` / `Ctrl+End` | Jump to top / bottom (re-enables auto-follow) |
| `Ctrl+O`, then `j`/`k` | Transcript mode: line-by-line scroll, `/` to search; `q` exits |

The mouse wheel can't scroll here — wheel events don't survive the five-layer nested stack (Neovim's `:terminal` captures them, and sidekick's nested tmux is a separate session). Keyboard keys propagate cleanly, so scrolling is keyboard-driven.

### Customizing keybindings

Claude Code reads custom shortcuts from `~/.claude/keybindings.json` (symlinked from `claude/.claude/keybindings.json` in this repo). Each entry maps a keystroke to a `namespace:action` within a context. Our one customization binds the line-scroll actions, which ship unbound by default:

```json
{
  "bindings": [
    { "context": "Scroll", "bindings": { "ctrl+up": "scroll:lineUp", "ctrl+down": "scroll:lineDown" } }
  ]
}
```

Changes apply live without a restart. If Neovim ever swallows `Ctrl+↑`/`Ctrl+↓`, swap to `alt+up`/`alt+down`. Full action and context reference: <https://code.claude.com/docs/en/keybindings>.

## Useful Commands

| Command | What it does |
| ------- | ------------ |
| `/clear` | Wipe conversation and start fresh (CLAUDE.md reloads) |
| `/compact` | Summarize conversation to reclaim context (lossy) |
| `/compact Focus on X` | Compact with focus instructions |
| `/rewind` | Restore code and conversation to a previous prompt |
| `/insights` | Analyze recent sessions for patterns — run weekly |
| `/config` → Output style | Switch output style (e.g. `explanatory`, `learning`); replaces the removed `/output-style` command |
| `/fast` | Toggle fast mode (same model, ~2.5x faster, 6x cost) |
| `/sandbox` | Enable OS-level filesystem and network sandboxing |
| `/simplify` | Review changed code for reuse, quality, and efficiency |

## Skills

| Skill | When to use |
| ----- | ----------- |
| `/resolve-issue 123` | Full workflow for a GitHub issue — research, plan, implement, verify; right-sizes its rigor to issue complexity |
| `/create-pr` | Create a PR with auto-generated description and issue linking (inferred from branch name) |
| `/simplify` | Post-implementation code review — run before creating a PR |
| `/autopilot 123 --to pr` | Carry one issue through the whole loop autonomously to a review-ready PR (or `--to merge` for small reversible changes) |
| `/autopilot-triage` | Start-of-day: vet open issues and queue the autonomy-ready ones (`autopilot-queued`) |
| `/autopilot-batch` | Fan out the `autopilot-queued` queue — one parallel worktree subagent per issue, Opus-reviewed |
| `/qa-triage-batch` | Fan out `/qa-triage` across the open `qa` reports — reconcile shared root causes across reports, one consolidated gate, then create the tech issues |

Custom skills live in `claude/.claude/skills/`; `/simplify` and `/code-review` are built-in Claude Code skills. Type `/` to browse the full list including PRD-specific skills (`/bootstrap-prd`, `/plan-phase`, `/debrief`, etc.).

### Common Workflow

```text
/resolve-issue 123  →  /simplify  →  /create-pr
```

## Context Management

- **One task per session.** Each feature, bug fix, or investigation should fit within a single context window. If a task is too large, break it into pieces.
- **Prefer `/clear` over `/compact`.** `/clear` is lossless — your CLAUDE.md reloads and git state is fresh. `/compact` is lossy compression. Default to `/clear` between tasks.
- **Two compactions = task was too large.** If you've compacted twice in a session, the task needs to be split.
- **Cut losses after two corrections.** If you've corrected Claude twice on the same issue, use `Esc Esc` to rewind to before the first wrong attempt, or `/clear` and start fresh with a better prompt.
- **Watch the statusline.** Green = plenty of context. Yellow = start wrapping up. Red = finish and start a new session.

## Session Handoff

- Commit your work, write a brief plan to a file, `/clear`, and point Claude at the plan file in the next session.
- `claude --continue` picks up the last session; `claude --resume` lets you choose from recent sessions. But a fresh session with a written handoff is usually cleaner.

## Subagents

- Subagents get their own context window — the main session only sees their summary. Use them deliberately for context-heavy research, documentation reading, or exploration that would bloat your main session.

## Weekly Habit

Run `/insights` once a week. When it surfaces a pattern, act on it: add a rule to CLAUDE.md, write a hook, or extract a repeated workflow into a skill.
