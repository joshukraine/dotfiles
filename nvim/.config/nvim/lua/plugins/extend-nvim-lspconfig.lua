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
        init_options = {
          addonSettings = {
            ["Ruby LSP Rails"] = {
              enablePendingMigrationsPrompt = false,
            },
          },
        },
      },
      -- https://github.com/standardrb/standard
      standardrb = {
        mason = false,
        cmd = { vim.fn.expand("~/.asdf/shims/standardrb"), "--lsp" },
        filetypes = { "ruby", "rakefile" },
      },
      -- https://herb-tools.dev/projects/language-server
      -- Not yet in nvim-lspconfig defaults; explicit path to Mason binary required
      herb_ls = {
        cmd = { vim.fn.stdpath("data") .. "/mason/bin/herb-language-server", "--stdio" },
      },
    },
  },
}
