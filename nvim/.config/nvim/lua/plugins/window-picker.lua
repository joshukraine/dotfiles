-- https://github.com/s1n7ax/nvim-window-picker
-- stylua: ignore
if true then return {} end

return {
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup()
    end,
  },
}
