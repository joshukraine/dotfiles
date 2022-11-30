local opts = {
  filetypes = {
    "typescript",
    "javascript",
    "javascriptreact",
    "typescriptreact",
    "vue",
    "json"
  },
  settings = {
    css = {
      lint = {
        unknownAtRules = "ignore"
      }
    }
  }
}

require("lvim.lsp.manager").setup("volar", opts)
