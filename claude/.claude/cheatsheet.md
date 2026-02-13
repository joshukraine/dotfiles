# Claude Code Cheatsheet

*Last updated: 2026-02-13*

Quick reference for usage tips, keyboard shortcuts, and workflow habits.

## Keyboard Shortcuts

| Shortcut | Action |
| ---------- | ------ |
| `Option+T` | Toggle extended thinking on/off for current session |
| `Esc Esc` | Open checkpoint/rewind menu |
| `Shift+Tab` | Accept suggested edits |

## Useful Commands

| Command | What it does |
| ------- | ------------ |
| `/clear` | Wipe conversation and start fresh (CLAUDE.md reloads) |
| `/compact` | Summarize conversation to reclaim context (lossy) |
| `/compact Focus on X` | Compact with focus instructions |
| `/rewind` | Restore code and conversation to a previous prompt |
| `/insights` | Analyze recent sessions for patterns — run weekly |
| `/output-style explanatory` | Explain patterns as it works (verbose) |
| `/output-style` | Reset to default output style |
| `/fast` | Toggle fast mode (same model, ~2.5x faster, 6x cost) |
| `/sandbox` | Enable OS-level filesystem and network sandboxing |

## Context Management

- **One task per session.** Each feature, bug fix, or investigation should fit
  within a single context window. If a task is too large, break it into pieces.
- **Prefer `/clear` over `/compact`.** `/clear` is lossless — your CLAUDE.md
  reloads and git state is fresh. `/compact` is lossy compression. Default to
  `/clear` between tasks.
- **Two compactions = task was too large.** If you've compacted twice in a
  session, the task needs to be split.
- **Cut losses after two corrections.** If you've corrected Claude twice on the
  same issue, use `Esc Esc` to rewind to before the first wrong attempt, or
  `/clear` and start fresh with a better prompt.
- **Watch the statusline.** Green = plenty of context. Yellow = start wrapping
  up. Red = finish and start a new session.

## Session Handoff

- Commit your work, write a brief plan to a file, `/clear`, and point Claude at
  the plan file in the next session.
- `claude --continue` picks up the last session; `claude --resume` lets you
  choose from recent sessions. But a fresh session with a written handoff is
  usually cleaner.

## Subagents

- Subagents get their own context window — the main session only sees their
  summary. Use them deliberately for context-heavy research, documentation
  reading, or exploration that would bloat your main session.

## Weekly Habit

Run `/insights` once a week. When it surfaces a pattern, act on it: add a rule
to CLAUDE.md, write a hook, or extract a repeated workflow into a command.
