-- Uncomment the conditional to disable this config.
-- stylua: ignore
-- if true then return {} end

return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = true,
    opts = {
      terminal_colors = true, -- add neovim terminal colors
      undercurl = true,
      underline = false,
      bold = true,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = false, -- invert background for search, diffs, statuslines and errors
      contrast = "soft", -- can be "hard", "soft" or empty string
      palette_overrides = {},
      overrides = {
        IncSearch = { fg = "#504945", bg = "#ebdbb2" },
        Search = { bg = "#665c54" },
        StatusLine = { link = "lualine_c_normal" },
        FlashLabel = { link = "DiffDelete" },
        YankyPut = { bg = "#ebdbb2" },
        YankyYanked = { bg = "#ebdbb2" },
      },
      dim_inactive = false,
      transparent_mode = false,
    },
  },
}
