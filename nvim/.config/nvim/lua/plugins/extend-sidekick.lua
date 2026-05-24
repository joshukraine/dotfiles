-- sidekick.nvim — primary AI CLI integration during the trial
-- claudecode.nvim is disabled (extend-claudecode.lua early-returns) so there
-- are no collisions on the <leader>a* namespace. LazyVim's sidekick defaults
-- handle the generic actions; <leader>ac is the one custom binding, kept as
-- claudecode muscle memory for "open and focus Claude" in a single keystroke.
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
    -- All other <leader>a* bindings inherit LazyVim's sidekick defaults:
    --   <leader>aa  Toggle CLI       <leader>at  Send This
    --   <leader>as  Select CLI       <leader>af  Send File
    --   <leader>ad  Detach           <leader>av  Send Visual (x mode)
    --   <leader>ap  Select Prompt
    -- Non-leader defaults: <c-.> Focus pane, <Tab> Accept NES, <leader>uN Toggle NES.
  },
}
