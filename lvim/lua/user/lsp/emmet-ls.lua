local opts = {
  filetypes = {
    "css",
    "eruby",
    "html",
    "javascript",
    "javascriptreact",
    "scss",
    "typescript",
    "typescriptreact",
    "vue",
  }
}
require("lvim.lsp.manager").setup("emmet_ls", opts)
