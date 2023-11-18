return {
  "neovim/nvim-lspconfig",
  opts = {
    diagnostics = {
      underline = true,
      update_in_insert = true,
      severity_sort = true,
      virtual_text = true,
      float = {
        source = "always", -- Or "if_many"
      },
      signs = true,
    },
    servers = {
      standardrb = {
        mason = false,
        cmd = { "standardrb", "--lsp" },
        filetypes = { "ruby", "rakefile" },
      },
      ruby_ls = {
        mason = false,
        cmd = { "ruby-lsp" },
        formatter = "auto",
      },
    },
  },
}
