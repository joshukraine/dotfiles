# Claude Code + Neovim

Last reviewed: 2026-07-01

How I run [Claude Code][claude-code] alongside [Neovim][neovim], why the layout is what it is, and how the [sidekick.nvim][sidekick-nvim] integration actually connects the two.

## Recommended layout: sidekick + a sibling tmux pane

One tmux window, split side by side:

```text
┌─────────────────────────────┬───────────────────┐
│                             │                   │
│   Neovim  (60%)             │   Claude Code     │
│                             │   (40%)           │
│                             │                   │
└─────────────────────────────┴───────────────────┘
        one tmux window, two sibling panes
```

Neovim and Claude Code are **sibling panes under a single tmux session** — Claude is its own process in its own pane, not something running inside the editor. Prearrange this in a tmuxinator profile so it comes up ready on every session.

### Why flat beats nested

There are two ways to run Claude next to Neovim, and the process topology is the whole story.

**Nested** — what you get by default when you launch Claude _from inside_ Neovim:

```text
tmux → Neovim → :terminal buffer → inner tmux (status off) → Claude
```

Every layer adds indirection. Copy/paste, scrollback, mouse selection, and URL-clicking all have to fight down through the Neovim terminal (libvterm) and a second, inner tmux. This is the friction that pushed me toward the fullscreen TUI as a workaround.

**Flat** — Claude in a sibling tmux pane:

```text
tmux → Claude          (Neovim is a sibling pane, not a parent)
```

Claude runs as a plain process in a plain tmux pane. Copy/paste, scrollback, mouse selection, and link-clicking behave exactly like any terminal, because there's nothing extra in the stack.

The objection you'd expect — _"doesn't a sibling pane cut Claude off from the editor?"_ — turns out not to apply, and that's the key insight below.

### How Neovim talks to a sibling Claude

Sidekick does **not** own or wrap the Claude process. It discovers every AI CLI running under any tmux pane (it walks each pane's process tree) and sends context by pasting into the target pane **over tmux** — `tmux load-buffer` followed by `tmux paste-buffer -t <pane_id>`. Because it targets a pane id, the pane can be anywhere on the tmux server and the send works identically. No WebSocket, no in-process bridge, no nesting.

Send-context and session bindings (from `extend-sidekick.lua` plus LazyVim's sidekick defaults):

| Binding | Action |
| --- | --- |
| `<leader>af` | Send file reference |
| `<leader>al` | Send the current line's text (custom) |
| `<leader>at` | Send `file:line:col` position context |
| `<leader>av` | Send visual selection (`x` mode) |
| `<leader>as` | Select / pick a CLI session |
| `<leader>ac` | Toggle Claude (custom; "open and focus Claude") |
| `<leader>ad` | Detach from the current session |
| `<c-g>` | Add buffer to Claude prompt as `@`-mention (custom; moved off `<c-b>` so Claude's own Ctrl+B passes through) |

The first time you send in a session, sidekick shows a **Select CLI tool** picker. Pick the right Claude pane and it _attaches_ — a **logical** bind that just records the pane id. It does **not** spawn a new tmux session or add any nesting. After that first pick, sends go straight to that pane with no further prompts, until you detach (`<leader>ad`) or the pane exits.

### Reading the "Select CLI tool" picker

Two icon columns, and neither is obvious at first:

**First icon (install / run status):**

| Icon | Meaning |
| --- | --- |
| cube / hexagon | Installed — this row _launches a fresh_ session (none running) |
| filled toggle | A session is already running |
| ✗ | Tool not installed (selecting it just errors and opens its site) |

**Second icon (where the session lives):**

| Icon | Meaning |
| --- | --- |
| wifi | External pane — flat, reached over tmux (this is the good one) |
| wifi with a slash | External and running, but **not yet attached** — flips to solid wifi once you attach. The slash means "not the active session," _not_ "no connection" |
| terminal | A Neovim-owned terminal session (the nested topology) |

The trailing label reinforces it: `[tmux:dotfiles]` is an external session (with its tmux session name), while a bare `[tmux]` is a Neovim-owned terminal session. The directory on the right is each session's working directory.

### Launching on the fly

If you fire `<leader>ac` from inside Neovim with no session running, `extend-sidekick.lua` sets `cli.mux.create = "split"` so Claude opens as a **40%-wide tmux split of the current session** (the 60/40 layout) instead of a nested Neovim terminal. The split settings (`vertical = true, size = 0.4`) mirror the `<prefix> v` tmux binding (`split-window -h -l 40%`).

Two things to expect on this path:

- Focus stays in Neovim — tmux opens the split detached (`-d`), and sidekick's focus step is a no-op for an external pane (it only focuses Neovim-owned terminals). Hop over with your usual tmux navigation.
- It only applies when Neovim itself runs inside tmux. Outside tmux, sidekick falls back to the Neovim terminal automatically.

For a prearranged tmuxinator layout this path isn't used at all — Claude is already running when Neovim starts, so `<leader>af`/`al`/`at` just discover and attach to it. `create = "split"` is purely the ad-hoc fallback.

## Setup notes

- **Config:** `nvim/.config/nvim/lua/plugins/extend-sidekick.lua`
- **Key settings:** `cli.mux.backend = "tmux"`, `enabled = true`, `create = "split"`, `split = { vertical = true, size = 0.4 }`
- **Persistence:** sessions live in tmux, not in Neovim, so they survive Neovim restarts. Quit and relaunch the editor and your Claude context is still in its pane.

## Appendix: why not claudecode.nvim

[claudecode.nvim][claudecode-nvim] was the previous integration (now retired; its config is kept in `extend-claudecode.lua` behind an early return so the revert path stays simple). It ran a WebSocket + MCP server _inside_ Neovim that the CLI connected back to, giving Claude richer, real-time editor awareness — but at the cost of tighter coupling to the editor process.

Sidekick trades some of that depth for a simpler, multiplexer-native model, and that trade is exactly what makes the flat sibling-pane layout above possible. It keeps the parts I actually used — sending selections, files, and lines as context — and drops the tighter coupling.

Kept as a decision record, here's what claudecode.nvim's bridge provided that sidekick does not:

| Feature | What it did |
| --- | --- |
| Real-time selection tracking | Claude could call `getCurrentSelection` / `getLatestSelection` to see what you were looking at, live |
| Native diff review | Proposed changes opened in a Neovim diff split to accept/reject in-editor |
| Open-editors awareness | Claude called `getOpenEditors` for passive context on your current focus |
| `openFile` with line targeting | Claude could drive the editor to a specific file/line/range |
| LSP diagnostics access | Claude read errors/warnings via `getDiagnostics` (`mcp__ide__getDiagnostics`) |

Technical details (historical): WebSocket (RFC 6455) + JSON-RPC 2.0 + MCP; pure-Lua server on `vim.loop` bound to `127.0.0.1`; discovery via lock files at `~/.claude/ide/[port].lock`; per-session UUID v4 auth token; required Neovim >= 0.8.0 and folke/snacks.nvim.

[claude-code]: https://www.anthropic.com/claude-code
[neovim]: https://neovim.io/
[sidekick-nvim]: https://github.com/folke/sidekick.nvim
[claudecode-nvim]: https://github.com/coder/claudecode.nvim
