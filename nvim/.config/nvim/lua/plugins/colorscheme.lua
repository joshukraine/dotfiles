return {
  { -- https://github.com/folke/tokyonight.nvim
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "moon" }, -- night, storm, day, moon
  },
  -- { -- https://github.com/catppuccin/nvim
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 1000,
  -- },
  -- { -- https://github.com/ellisonleao/gruvbox.nvim
  --   "ellisonleao/gruvbox.nvim",
  --   priority = 1000,
  --   config = true,
  --   opts = {},
  -- },

  -- Configure LazyVim to load the desired colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
