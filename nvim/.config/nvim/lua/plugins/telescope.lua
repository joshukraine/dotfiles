-- https://www.lazyvim.org/configuration/plugins#%EF%B8%8F-adding--disabling-plugin-keymaps

return {
  "nvim-telescope/telescope.nvim",
  keys = {
    -- disable the keymap to grep files
    { "<leader>sR", false },
    -- change a keymap
    { "<leader>sx", "<cmd>Telescope resume<cr>", desc = "Resume" },
  },
}
