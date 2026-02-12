return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      local my_tools = {
        "bash-language-server",
        "css-lsp",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "eslint-lsp",
        "flake8",
        "hadolint",
        "herb-language-server",
        "html-lsp",
        "json-lsp",
        "lua-language-server",
        "markdown-toc",
        "markdownlint",
        "markdownlint-cli2",
        "marksman",
        "prettier",
        "shellcheck",
        "shfmt",
        "sqlfluff",
        "stylua",
        "tailwindcss-language-server",
        "taplo",
        "typescript-language-server",
        "vim-language-server",
        "vue-language-server",
        "yaml-language-server",
      }
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, my_tools)

      -- Remove erb-formatter and erb-lint added by LazyVim's Ruby extra
      -- (replaced by herb-language-server)
      local excluded = { "erb-formatter", "erb-lint" }
      opts.ensure_installed = vim.tbl_filter(function(pkg)
        return not vim.tbl_contains(excluded, pkg)
      end, opts.ensure_installed)
    end,
  },
}
