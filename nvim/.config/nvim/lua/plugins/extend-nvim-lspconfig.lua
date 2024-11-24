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
    servers = {
      -- https://github.com/Shopify/ruby-lsp/blob/main/EDITORS.md
      ruby_lsp = {
        mason = false,
        cmd = { "/Users/joshukraine/.asdf/shims/ruby-lsp" },
        formatter = "auto",
      },
      -- https://github.com/standardrb/standard
      standardrb = {
        mason = false,
        cmd = { "/Users/joshukraine/.asdf/shims/standardrb", "--lsp" },
        filetypes = { "ruby", "rakefile" },
      },
    },
  },
}
