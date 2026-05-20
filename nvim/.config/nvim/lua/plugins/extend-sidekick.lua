-- sidekick.nvim — parallel trial alongside claudecode.nvim
-- All sidekick CLI keymaps namespaced under <leader>ai* to avoid colliding
-- with claudecode's <leader>aa/af/as/ad bindings. NES stays on <Tab>.
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
    },
    nes = {
      enabled = true,
    },
  },
  -- stylua: ignore
  keys = {
    -- Disable LazyVim sidekick defaults that collide with claudecode.
    { "<leader>aa", false },
    { "<leader>af", false },
    { "<leader>as", false },
    { "<leader>ad", false },
    { "<leader>at", false },
    { "<leader>av", false },
    { "<leader>ap", false },

    -- Re-bind under <leader>ai* namespace.
    { "<leader>ai", "", desc = "+sidekick", mode = { "n", "v" } },
    {
      "<leader>aii",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick: Toggle CLI",
    },
    {
      "<leader>ais",
      function() require("sidekick.cli").select() end,
      desc = "Sidekick: Select CLI",
    },
    {
      "<leader>aid",
      function() require("sidekick.cli").close() end,
      desc = "Sidekick: Detach session",
    },
    {
      "<leader>ait",
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      mode = { "n", "x" },
      desc = "Sidekick: Send This",
    },
    {
      "<leader>aiF",
      function() require("sidekick.cli").send({ msg = "{file}" }) end,
      desc = "Sidekick: Send File",
    },
    {
      "<leader>aiv",
      function() require("sidekick.cli").send({ msg = "{selection}" }) end,
      mode = { "x" },
      desc = "Sidekick: Send Visual Selection",
    },
    {
      "<leader>aip",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Sidekick: Select Prompt",
    },
    -- Non-leader bindings kept at defaults: <c-.> Focus, <Tab> NES, <leader>uN Toggle NES.
  },
}
