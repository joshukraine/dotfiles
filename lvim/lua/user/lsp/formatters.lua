local formatters = require("lvim.lsp.null-ls.formatters")

formatters.setup({
  {
    command = "prettier",
    filetypes = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "vue",
    },
  },
  {
    command = "yamlfmt",
  },
  {
    command = "stylua",
  },
})
