-- ClaudeCode.nvim configuration — RETIRED in favor of sidekick.nvim.
-- This config is kept in place (disabled via early-return below) so the
-- revert path stays simple. To re-enable claudecode and step back from
-- sidekick:
--   1. Remove the `if true then return {} end` line below.
--   2. In nvim/.config/nvim/lazyvim.json, re-add the extras:
--        "lazyvim.plugins.extras.ai.claudecode"
--        "lazyvim.plugins.extras.ai.copilot"   (if you want copilot back)
--   3. In extend-blink.lua, re-add "copilot" to opts.sources.default.
--   4. Optionally drop sidekick: remove "lazyvim.plugins.extras.ai.sidekick"
--      from lazyvim.json and delete extend-sidekick.lua.
-- Reference: https://github.com/coder/claudecode.nvim

-- stylua: ignore
if true then return {} end

return {
  "coder/claudecode.nvim",
  opts = {
    -- Terminal display configuration
    terminal = {
      split_side = "right",
      split_width_percentage = 0.40,
      auto_close = false,
    },

    -- Server configuration
    auto_start = true, -- Launch server automatically
    log_level = "info", -- Options: trace, debug, info, warn, error

    -- Working directory control
    git_repo_cwd = true, -- Use git repository root as working directory

    -- Diff management (controls how diffs display in the editor)
    -- To keep diffs in the terminal only, run `/config` in Claude Code and
    -- set "Diff tool" to "terminal". When set to "auto" (default), diffs
    -- are sent to this plugin and displayed using the options below.
    diff_opts = {
      layout = "vertical", -- Side-by-side diff display
      open_in_new_tab = true, -- Isolate diffs in dedicated tabs
      hide_terminal_in_new_tab = false, -- Keep terminal visible during diff review
      keep_terminal_focus = true, -- Stay in terminal when diff opens
      on_new_file_reject = "close_window", -- Clean up windows on reject
    },

    -- Context integration
    track_selection = true, -- Send highlighted text as context
    visual_demotion_delay_ms = 50, -- Debounce selection updates
    focus_after_send = false, -- Keep focus in editor after sending context
  },

  -- Optional: Override default keybindings here if needed
  -- Default keybindings provided by LazyVim extra:
  -- <leader>ac - Toggle Claude terminal
  -- <leader>af - Focus Claude
  -- <leader>ar - Resume previous session
  -- <leader>aC - Continue Claude's work
  -- <leader>am - Select model variant
  -- <leader>ab - Add current buffer to context
  -- <leader>as - Send selection (visual mode) or add file
  -- <leader>aa - Accept proposed changes
  -- <leader>ad - Deny proposed changes
  --
  -- keys = {
  --   { "<leader>ac", "<cmd>ClaudeToggle<cr>", desc = "Toggle Claude" },
  --   { "<leader>af", "<cmd>ClaudeFocus<cr>", desc = "Focus Claude" },
  --   -- ... add more custom keybindings as needed
  -- },
}
