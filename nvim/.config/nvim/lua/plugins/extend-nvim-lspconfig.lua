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
      -- Extend html-lsp to also serve gotmpl files (Hugo templates)
      html = {
        filetypes = { "html", "gotmpl" },
      },
      -- https://herb-tools.dev/projects/language-server
      -- Not yet in nvim-lspconfig defaults; explicit path to Mason binary required
      herb_ls = {
        cmd = { vim.fn.stdpath("data") .. "/mason/bin/herb-language-server", "--stdio" },
        filetypes = { "eruby" },
      },
      -- Obsidian vault: silence Marksman's link diagnostics. They're false positives
      -- here — Marksman can't resolve Obsidian wikilinks (escaped `\|` aliases in
      -- tables, vault-wide name resolution), and Obsidian itself is the authority on
      -- link resolution. Completion / go-to-definition / hover stay active, and
      -- Markdown in other projects keeps normal Marksman diagnostics.
      marksman = {
        handlers = {
          ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
            local vault = vim.fn.expand("~/obsidian-vault")
            if result and result.uri and vim.uri_to_fname(result.uri):sub(1, #vault) == vault then
              result.diagnostics = {}
            end
            return vim.lsp.handlers["textDocument/publishDiagnostics"](err, result, ctx, config)
          end,
        },
      },
    },
  },
}
