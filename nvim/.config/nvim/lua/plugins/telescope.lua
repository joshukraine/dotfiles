-- https://www.lazyvim.org/configuration/plugins#%EF%B8%8F-adding--disabling-plugin-keymaps

return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>sR", false },
    { "<leader>sx", "<cmd>Telescope resume<cr>", desc = "Resume" },
  },
}
