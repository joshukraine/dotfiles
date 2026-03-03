# ClaudeCode.nvim vs Running Claude Code in tmux

Last reviewed: 2026-03-03

## Context

[ClaudeCode.nvim](https://github.com/coder/claudecode.nvim) is a Neovim plugin that runs a WebSocket-based MCP server inside Neovim, implementing the same protocol as Anthropic's official VS Code extension. Claude Code CLI auto-discovers and connects to this server, creating a two-way communication bridge between the editor and the CLI.

The alternative is running Claude Code in a tmux pane adjacent to Neovim, where the CLI operates standalone with no editor integration.

## Features Provided by ClaudeCode.nvim

### Significant

| Feature | What it does | tmux equivalent |
| --- | --- | --- |
| **Selection context sending** | `<leader>as` sends your visual selection or tree explorer file directly to Claude as context | Copy-paste or describe manually |
| **Real-time selection tracking** | Plugin tracks cursor position and visual selections; Claude can call `getCurrentSelection` / `getLatestSelection` to see what you're looking at | None — Claude has no editor awareness |
| **Native diff review** | Claude's proposed changes open in a Neovim diff split; you can review, modify, then accept (`<leader>aa`) or reject (`<leader>ad`) | Claude edits files directly; you review via `git diff` after the fact |
| **Open editors awareness** | Claude calls `getOpenEditors` to see which files you have open, providing passive context about your current focus | None |
| **`openFile` with line targeting** | Claude can open a specific file at a specific line or highlight a text range in your editor | Claude tells you where to look but can't drive the editor |
| **LSP diagnostics access** | Claude calls `getDiagnostics` (via `mcp__ide__getDiagnostics`) to read errors/warnings from your LSP | None — you'd need to paste error output |

### Minor

| Feature | What it does |
| --- | --- |
| **`checkDocumentDirty` / `saveDocument`** | Claude can check for unsaved changes and save files through Neovim |
| **`getWorkspaceFolders`** | Claude gets workspace folder context |
| **Tree explorer integration** | Add files from nvim-tree, neo-tree, oil.nvim, or mini.files to Claude's context via `<leader>as` |
| **`closeAllDiffTabs`** | Claude can clean up diff views it opened |

## What You Keep in tmux

Everything core to Claude Code itself works standalone:

- File reading, writing, and editing (Read, Write, Edit tools)
- Code search (Grep, Glob)
- Bash command execution
- Git operations
- Web search and fetch
- All MCP servers (Context7, Chrome automation, etc.)
- Agent subprocesses and parallel tool calls

The plugin adds editor *awareness*, not editor *capability*.

## LazyVim Extra Configuration

When enabled as a LazyVim extra (`lazyvim.plugins.extras.ai.claudecode`), it configures:

- `<leader>ac` — toggle Claude Code terminal
- `<leader>af` — focus Claude Code window
- `<leader>ar` — resume prior session
- `<leader>aC` — continue work
- `<leader>ab` — add current buffer as context
- `<leader>as` — send selection (visual) or add file (tree explorer)
- `<leader>aa` — accept diff
- `<leader>ad` — reject diff

## Decision Factors

**Favor the plugin if:**

- You frequently send selections or files to Claude as context
- You want to review diffs in-editor before they land
- You value Claude having passive awareness of your editor state (open files, cursor position, LSP errors)

**Favor tmux if:**

- Window/pane management within Neovim feels cumbersome
- Most of your interaction is task-oriented (describe what to do, Claude does it)
- You rarely use visual selection sending or diff review
- You prefer the simplicity of a standalone terminal session

## Technical Details

- **Protocol**: WebSocket (RFC 6455) + JSON-RPC 2.0 + MCP
- **Server**: Pure Lua using `vim.loop`, binds to `127.0.0.1` only
- **Discovery**: Lock files at `~/.claude/ide/[port].lock`
- **Auth**: UUID v4 token per session, validated via WebSocket handshake header
- **Requirements**: Neovim >= 0.8.0, Claude Code CLI, folke/snacks.nvim
