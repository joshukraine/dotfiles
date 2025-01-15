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
      -- https://shopify.github.io/ruby-lsp/editors.html#lazyvim-lsp
      ruby_lsp = {
        mason = false,
        cmd = { vim.fn.expand("~/.asdf/shims/ruby-lsp") },
      },
      -- https://github.com/standardrb/standard
      standardrb = {
        mason = false,
        cmd = { vim.fn.expand("~/.asdf/shims/standardrb"), "--lsp" },
        filetypes = { "ruby", "rakefile" },
      },
    },
  },
}
