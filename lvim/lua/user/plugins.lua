-- Additional Plugins
lvim.plugins = {
  { "arcticicestudio/nord-vim" }, -- Vim colorscheme based on the Nord color palette | https://github.com/arcticicestudio/nord-vim
  { "vim-ruby/vim-ruby" }, -- Vim/Ruby Configuration Files | https://github.com/vim-ruby/vim-ruby
  { "kana/vim-textobj-user" }, -- Create your own text objects | https://github.com/kana/vim-textobj-user
  { "nelstrom/vim-textobj-rubyblock" }, -- A custom text object for selecting ruby blocks | https://github.com/nelstrom/vim-textobj-rubyblock
  { "christoomey/vim-tmux-navigator" }, -- Seamless navigation between tmux panes and vim splits | https://github.com/christoomey/vim-tmux-navigator
  { "janko/vim-test" },
  { "christoomey/vim-tmux-runner" }, -- Command runner for sending commands from vim to tmux. | https://github.com/christoomey/vim-tmux-runner
  { "tpope/vim-surround" },
  { "tpope/vim-rails" },
  { "tpope/vim-obsession" },
  { "sdras/vue-vscode-snippets" }, -- Vue VSCode Snippets | https://github.com/sdras/vue-vscode-snippets
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("n", "s", ":HopChar2<cr>", { silent = true })
      vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
    end,
  },
  { -- https://github.com/wfxr/minimap.vim
    'wfxr/minimap.vim',
    run = "cargo install --locked code-minimap",
    -- cmd = {"Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight"},
    config = function()
      vim.cmd("let g:minimap_width = 10")
      vim.cmd("let g:minimap_auto_start = 1")
      vim.cmd("let g:minimap_auto_start_win_enter = 1")
    end,
  },
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
