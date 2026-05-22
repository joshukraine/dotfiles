# Sidekick.nvim Trial

Parallel trial of [folke/sidekick.nvim](https://github.com/folke/sidekick.nvim) alongside the existing [coder/claudecode.nvim](https://github.com/coder/claudecode.nvim) integration. Lives on branch `chore/sidekick-trial`.

## Why a trial

claudecode.nvim remains the deeper Claude-specific integration (MCP/WebSocket protocol, live selection tracking, native diff-review). Sidekick brings three things worth evaluating:

1. **Multi-CLI hub** — same UI for Claude, Codex, Gemini, Grok, Aider, OpenCode, Copilot CLI, Cursor, Crush, Qwen, Amazon Q. Useful if branching into other models or recommending a setup to others.
2. **tmux-paned sessions** — AI sessions live in tmux panes (not Neovim terminal splits) and survive Neovim restarts.
3. **NES (Next Edit Suggestion)** — Copilot LSP's multi-line refactoring suggestions with inline diff, triggered on pause. Distinct from Claude Code's agentic loop.

## Keymap cheat sheet

### claudecode (unchanged)

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>ac` | n | Toggle Claude |
| `<leader>af` | n | Focus Claude |
| `<leader>ar` | n | Resume Claude |
| `<leader>aC` | n | Continue Claude |
| `<leader>ab` | n | Add current buffer |
| `<leader>as` | v | Send selection |
| `<leader>as` | n (tree) | Add file |
| `<leader>aa` | n | Accept diff |
| `<leader>ad` | n | Deny diff |

### sidekick (new)

Primary toggles are flat 3-keystroke bindings; secondary actions sit under the `<leader>ak*` group.

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>ai` | n | Toggle CLI (last-used, or picker if none) |
| `<leader>aj` | n | Toggle Claude directly (skip picker) |
| `<leader>aks` | n | Select CLI from picker |
| `<leader>akd` | n | Detach session |
| `<leader>akt` | n, x | Send "this" (cursor context or visual) |
| `<leader>akf` | n | Send file |
| `<leader>akv` | x | Send visual selection |
| `<leader>akp` | n, x | Pick a built-in prompt (explain, fix, review, tests, …) |

### sidekick non-leader (defaults kept)

| Key | Mode | Action |
| --- | --- | --- |
| `<C-.>` | n, t, i, x | Focus sidekick from anywhere |
| `<Tab>` | n | Accept NES suggestion |
| `<leader>uN` | n | Toggle NES on/off |

## First-run checklist

1. Quit nvim, relaunch. Lazy will install `folke/sidekick.nvim` and uninstall `copilot.lua` / `copilot-cmp`.
2. Copilot LSP needs to be installed and signed in. Run `:LspCopilotSignIn` if NES doesn't fire after a few seconds of editing.
3. **Verify tmux integration**: from inside tmux, `<leader>ai` should open Claude in a new tmux pane (not a Neovim terminal split). Detach Neovim — the pane survives.
4. **Try NES**: edit a function so it's "obviously incomplete" (rename a param, leave a TODO). After a brief pause, ghost-text diff should appear. `<Tab>` accepts.
5. **Try the multi-CLI hub**: `<leader>aks` to see the picker. Gives a feel for what could be useful to recommend to others.

## Gotchas

- **Two parallel Claude sessions.** Toggling both plugins at once spawns two independent Claude instances (claudecode uses MCP/WebSocket; sidekick spawns a tmux-paned CLI). They don't share context — that's expected for the trial.
- **`copilot.lua` is gone for the duration of the trial.** The LazyVim copilot extra was removed because sidekick's NES needs the standalone Copilot LSP server, which conflicts with copilot.lua's bundled one. No more `<M-]>` / `<M-[>` ghost-text suggestions — NES via `<Tab>` is the replacement.
- **Neovim 0.11.2+ required.** Confirmed on current setup (0.12.2).

## Trial evaluation questions

After ~2 weeks, ask:

- Did NES become part of muscle memory, or was it ignored?
- Did tmux-paned sessions surviving restart matter in practice, or was it novelty?
- Did the multi-CLI hub get exercised, or is Claude still the only thing in use?
- Anything claudecode does that's now missed (live selection sync, diff-review-before-accept)?

## How to revert

```bash
git checkout master
git branch -D chore/sidekick-trial
```

Then relaunch nvim — Lazy will reinstall `copilot.lua` and remove sidekick.

If keeping sidekick but restoring `copilot.lua` (unlikely — they conflict), set `nes.enabled = false` in `extend-sidekick.lua` and re-add `lazyvim.plugins.extras.ai.copilot` to `lazyvim.json`.

## References

- Comparison report and recommendation rationale: see commit message on `chore/sidekick-trial`
- Sidekick README: <https://github.com/folke/sidekick.nvim>
- Claudecode README: <https://github.com/coder/claudecode.nvim>
- LazyVim sidekick extra: <https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/ai/sidekick.lua>
