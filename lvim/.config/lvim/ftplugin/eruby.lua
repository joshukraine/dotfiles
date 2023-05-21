local opts = {
  filetypes = {
    "eruby",
    "html",
  },
}

require("lvim.lsp.manager").setup("html", opts)
