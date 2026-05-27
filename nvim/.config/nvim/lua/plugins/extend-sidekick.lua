-- sidekick.nvim — primary AI CLI integration.
-- claudecode.nvim is retired but its config is kept in extend-claudecode.lua
-- (early-returns) so the revert path stays straightforward. LazyVim's sidekick
-- defaults handle the generic <leader>a* actions; <leader>ac is the one custom
-- binding, kept as claudecode muscle memory for "open and focus Claude" in a
-- single keystroke.
-- Reference: https://github.com/folke/sidekick.nvim

return {
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
}
