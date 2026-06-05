-- sidekick.nvim — primary AI CLI integration.
-- claudecode.nvim is retired but its config is kept in extend-claudecode.lua
-- (early-returns) so the revert path stays straightforward. LazyVim's sidekick
-- defaults handle the generic <leader>a* actions; <leader>ac is the one custom
-- binding, kept as claudecode muscle memory for "open and focus Claude" in a
-- single keystroke.
-- Reference: https://github.com/folke/sidekick.nvim

return {
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        -- Spawn AI CLIs inside tmux panes so sessions survive Neovim restarts.
        mux = {
          backend = "tmux",
          enabled = true,
        },
        win = {
          layout = "right",
          -- Size the right split to 40% of editor width on each open.
          config = function(terminal)
            terminal.opts.split.width = math.floor(vim.o.columns * 0.40)
          end,
        },
      },
      nes = {
        enabled = true,
      },
    },
  -- stylua: ignore
  keys = {
    -- Remove LazyVim's `<leader>a` group stub. The sidekick extra declares the
    -- "+ai" group with `{ "<leader>a", "", desc = "+ai" }`, and lazy.nvim
    -- materializes that empty rhs as a real <Nop> keymap (see lazy.nvim's
    -- handler/keys.lua `is_nop`). That makes <leader>a an *ambiguous* mapping:
    -- a complete <Nop> command AND the prefix for <leader>ac/aa/al/... So after
    -- <leader>a, Neovim stalls for `timeoutlen` (300ms) waiting to disambiguate
    -- — if the next key is late the <Nop> fires and the key leaks into normal
    -- mode (e.g. `c` becomes a change operator). Disabling it with `false`
    -- leaves <leader>a as a pure prefix, so <leader>ac fires instantly with no
    -- timeout. The "+ai" which-key label is restored via the which-key spec below.
    { "<leader>a", false, mode = { "n", "v" } },
    {
      "<leader>ac",
      function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
      desc = "Sidekick: Toggle Claude",
    },
    -- {line} sends just the line text, where {this} (LazyVim's <leader>at)
    -- sends "file:line:col" position context. Useful for asking about the
    -- literal content of a line without the surrounding location metadata.
    {
      "<leader>al",
      function() require("sidekick.cli").send({ msg = "{line}" }) end,
      mode = { "x", "n" },
      desc = "Sidekick: Send Line",
    },
    -- All other <leader>a* bindings inherit LazyVim's sidekick defaults:
    --   <leader>aa  Toggle CLI       <leader>at  Send This
    --   <leader>as  Select CLI       <leader>af  Send File
    --   <leader>ad  Detach           <leader>av  Send Visual (x mode)
    --   <leader>ap  Select Prompt
    -- Non-leader defaults: <c-.> Focus pane, <Tab> Accept NES, <leader>uN Toggle NES.
  },
  },
  -- Restore the "+ai" which-key label that the disabled <leader>a stub used to
  -- provide. A which-key `group` is a pure label — it does NOT create a real
  -- keymap, so <leader>a stays a non-ambiguous prefix and no timeout returns.
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>a", group = "ai", mode = { "n", "v" } },
      },
    },
  },
}
