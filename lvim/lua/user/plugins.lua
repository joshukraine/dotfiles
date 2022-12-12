lvim.plugins = {
  -- { -- One dark and light colorscheme for neovim >= 0.5.0 written in lua | https://github.com/navarasu/onedark.nvim
  --   "navarasu/onedark.nvim",
  --   config = function()
  --     require("onedark").setup {
  --       style = "deep"
  --     }
  --     require("onedark").load()
  --   end
  -- },
  { "vim-ruby/vim-ruby" }, -- Vim/Ruby Configuration Files | https://github.com/vim-ruby/vim-ruby
  { "kana/vim-textobj-user" }, -- Create your own text objects | https://github.com/kana/vim-textobj-user
  { "nelstrom/vim-textobj-rubyblock" }, -- A custom text object for selecting ruby blocks | https://github.com/nelstrom/vim-textobj-rubyblock
  { "christoomey/vim-tmux-navigator" }, -- Seamless navigation between tmux panes and vim splits | https://github.com/christoomey/vim-tmux-navigator
  { "tpope/vim-surround" },
  { "tpope/vim-rails" },
  { "tpope/vim-repeat" },
  { "tpope/vim-obsession" },
  { "sdras/vue-vscode-snippets" }, -- Vue VSCode Snippets | https://github.com/sdras/vue-vscode-snippets
  {
    "janko/vim-test",
    config = function()
      vim.cmd("let test#strategy = 'vtr'")
    end,
  },
  {
    "christoomey/vim-tmux-runner",
    config = function()
      vim.cmd("let g:VtrPercentage = 25")
      vim.cmd("let g:VtrUseVtrMaps = 0")
    end,
  }, -- Command runner for sending commands from vim to tmux. | https://github.com/christoomey/vim-tmux-runner
  { -- https://github.com/andymass/vim-matchup
    "andymass/vim-matchup",
    event = "CursorMoved",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    'wfxr/minimap.vim',
    run = "cargo install --locked code-minimap",
    -- cmd = {"Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight"},
    config = function()
      vim.cmd("let g:minimap_width = 10")
      vim.cmd("let g:minimap_auto_start = 0")
      vim.cmd("let g:minimap_auto_start_win_enter = 0")
    end,
  },
  { -- https://github.com/windwp/nvim-ts-autotag
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  { -- https://github.com/norcalli/nvim-colorizer.lua
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
    "ggandor/lightspeed.nvim",
    event = "BufRead",
  },
  { -- Use ‘curly’ quote characters in Vim | https://github.com/reedes/vim-textobj-quote
    "reedes/vim-textobj-quote"
  },
  { -- Asciidoctor plugin for Vim | https://github.com/habamax/vim-asciidoctor
    "habamax/vim-asciidoctor"
  }
}
