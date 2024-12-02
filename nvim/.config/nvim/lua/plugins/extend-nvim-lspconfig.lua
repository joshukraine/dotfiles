return {
  "neovim/nvim-lspconfig",
  opts = {
    diagnostics = {
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      virtual_text = true,
      float = {
        source = "always", -- Or "if_many"
      },
      signs = true,
    },
  },
}
