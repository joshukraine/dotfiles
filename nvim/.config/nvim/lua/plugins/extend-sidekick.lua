-- sidekick.nvim — parallel trial alongside claudecode.nvim
-- The two primary toggles live at <leader>ai / <leader>aj (3 keystrokes).
-- Secondary actions sit under the <leader>ak* group. None of these collide
-- with claudecode's <leader>a{c,a,f,r,C,m,b,s,d} bindings. NES stays on <Tab>.
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
    -- Disable LazyVim sidekick defaults that collide with claudecode.
    { "<leader>aa", false },
    { "<leader>af", false },
    { "<leader>as", false },
    { "<leader>ad", false },
    { "<leader>at", false },
    { "<leader>av", false },
    { "<leader>ap", false },

    -- Primary toggles promoted to 3-keystroke bindings (no group prefix to
    -- pause on). Each is a complete mapping with no longer sibling, so there
    -- is no complete-vs-prefix ambiguity and no timeoutlen wait.
    {
      "<leader>ai",
      function() require("sidekick.cli").toggle() end,
      desc = "Sidekick: Toggle CLI",
    },
    {
      "<leader>aj",
      function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
      desc = "Sidekick: Toggle Claude",
    },

    -- Secondary actions under a proper which-key group. Declared with `group`
    -- (not an empty-string rhs) so <leader>ak is a pure prefix, never a
    -- firing mapping.
    { "<leader>ak", group = "sidekick", mode = { "n", "x" } },
    {
      "<leader>aks",
      function() require("sidekick.cli").select() end,
      desc = "Sidekick: Select CLI",
    },
    {
      "<leader>akd",
      function() require("sidekick.cli").close() end,
      desc = "Sidekick: Detach session",
    },
    {
      "<leader>akt",
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      mode = { "n", "x" },
      desc = "Sidekick: Send This",
    },
    {
      "<leader>akf",
      function() require("sidekick.cli").send({ msg = "{file}" }) end,
      desc = "Sidekick: Send File",
    },
    {
      "<leader>akv",
      function() require("sidekick.cli").send({ msg = "{selection}" }) end,
      mode = { "x" },
      desc = "Sidekick: Send Visual Selection",
    },
    {
      "<leader>akp",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Sidekick: Select Prompt",
    },
    -- Non-leader bindings kept at defaults: <c-.> Focus, <Tab> NES, <leader>uN Toggle NES.
  },
}
