lvim.plugins = {
  -- General
  {
    -- General-purpose motion plugin | https://github.com/ggandor/leap.nvim
    "ggandor/leap.nvim",
    dependencies = { "tpope/vim-repeat" },
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    config = function()
      require("persistence").setup({
        dir = vim.fn.expand(vim.fn.stdpath("config") .. "/session/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
      })
    end,
  },
  { "tpope/vim-repeat" },
  { "tpope/vim-surround" },

  -- Ruby/Rails/Vue
  { "kana/vim-textobj-user" }, -- Create your own text objects | https://github.com/kana/vim-textobj-user
  -- { "nelstrom/vim-textobj-rubyblock" }, -- A custom text object for selecting ruby blocks | https://github.com/nelstrom/vim-textobj-rubyblock
  { "sdras/vue-vscode-snippets" }, -- Vue VSCode Snippets | https://github.com/sdras/vue-vscode-snippets
  { "tpope/vim-rails" }, -- Ruby on Rails power tools | https://github.com/tpope/vim-rails
  { "vim-ruby/vim-ruby" }, -- Vim/Ruby Configuration Files | https://github.com/vim-ruby/vim-ruby

  -- Testing
  { "vim-test/vim-test" }, -- A Vim wrapper for running tests on different granularities | https://github.com/vim-test/vim-test

  -- Kitty
  {
    -- Seamless navigation between kitty panes and vim splits | https://github.com/knubie/vim-kitty-navigator
    "knubie/vim-kitty-navigator",
    build = "cp ./*.py ~/.config/kitty/",
  },

  -- Tmux
  -- {
  --   -- Seamless navigation between tmux panes and vim splits | https://github.com/christoomey/vim-tmux-navigator
  --   "christoomey/vim-tmux-navigator",
  --   lazy = false,
  -- },
  -- { "christoomey/vim-tmux-runner" }, -- Command runner for sending commands from vim to tmux. | https://github.com/christoomey/vim-tmux-runner

  -- Markdown & AsciiDoc
  { "habamax/vim-asciidoctor" }, -- Asciidoctor plugin for Vim | https://github.com/habamax/vim-asciidoctor
  { "reedes/vim-textobj-quote" }, -- Use ‘curly’ quote characters in Vim | https://github.com/reedes/vim-textobj-quote

  -- Misc
  {
    -- Use treesitter to autoclose and autorename html tags | https://github.com/windwp/nvim-ts-autotag
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    -- A high-performance color highlighter for Neovim | https://github.com/norcalli/nvim-colorizer.lua
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "css", "scss", "html", "javascript" }, {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      })
    end,
  },
  {
    -- Blazing fast minimap/scrollbar in Lua | https://github.com/echasnovski/mini.map/
    "echasnovski/mini.map",
    branch = "stable",
    config = function()
      require("mini.map").setup()
      local map = require("mini.map")
      map.setup({
        integrations = {
          map.gen_integration.builtin_search(),
          map.gen_integration.diagnostic({
            error = "DiagnosticFloatingError",
            warn = "DiagnosticFloatingWarn",
            info = "DiagnosticFloatingInfo",
            hint = "DiagnosticFloatingHint",
          }),
          map.gen_integration.gitsigns({
            add = "GitSignsAdd",
            change = "GitSignsChange",
            delete = "GitSignsDelete",
          }),
        },
        symbols = {
          encode = map.gen_encode_symbols.dot("4x2"),
        },
        window = {
          side = "right",
          width = 15, -- set to 1 for a pure scrollbar :)
          winblend = 15,
          show_integration_count = false,
        },
      })
    end,
  },
}
