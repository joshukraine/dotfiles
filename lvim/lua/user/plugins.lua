lvim.plugins = {
  { "arcticicestudio/nord-vim" }, -- Vim colorscheme based on the Nord color palette | https://github.com/arcticicestudio/nord-vim
  { "vim-ruby/vim-ruby" }, -- Vim/Ruby Configuration Files | https://github.com/vim-ruby/vim-ruby
  { "kana/vim-textobj-user" }, -- Create your own text objects | https://github.com/kana/vim-textobj-user
  { "nelstrom/vim-textobj-rubyblock" }, -- A custom text object for selecting ruby blocks | https://github.com/nelstrom/vim-textobj-rubyblock
  { "christoomey/vim-tmux-navigator" }, -- Seamless navigation between tmux panes and vim splits | https://github.com/christoomey/vim-tmux-navigator
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
  { "tpope/vim-surround" },
  { "tpope/vim-rails" },
  { "tpope/vim-obsession" },
  { "sdras/vue-vscode-snippets" }, -- Vue VSCode Snippets | https://github.com/sdras/vue-vscode-snippets
  { -- https://github.com/andymass/vim-matchup
    "andymass/vim-matchup",
    event = "CursorMoved",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  { -- https://github.com/folke/trouble.nvim
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
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
}
