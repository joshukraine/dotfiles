lvim.builtin.which_key.mappings["1"] = { ":Obsession<CR>", "Toggle Session" }
lvim.builtin.which_key.mappings["2"] = {
  "<cmd>lua require('user.functions').toggle_colorcolumn()<CR>",
  "ColorColumn"
}
lvim.builtin.which_key.mappings["3"] = {
  "<cmd>lua require('user.functions').toggle_option('relativenumber')<CR>",
  "RelativeNumber"
}
lvim.builtin.which_key.mappings["4"] = { "<C-^>", "Previous Buffer" }
lvim.builtin.which_key.mappings["5"] = {
  "<cmd>lua require('user.functions').toggle_option('wrap')<CR>",
  "Wrap"
}
lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<CR>", "Save without formatting" }
lvim.builtin.which_key.mappings["b-"] = { ":wincmd _<CR>:wincmd |<CR>", "Zoom Window In" }
lvim.builtin.which_key.mappings["b="] = { ":wincmd =<CR>", "Balance Windows" }

lvim.builtin.which_key.mappings["t"] = {
  name = "Diagnostics",
  t = { "<cmd>TroubleToggle<CR>", "trouble" },
  w = { "<cmd>TroubleToggle workspace_diagnostics<CR>", "workspace" },
  d = { "<cmd>TroubleToggle document_diagnostics<CR>", "document" },
  q = { "<cmd>TroubleToggle quickfix<CR>", "quickfix" },
  l = { "<cmd>TroubleToggle loclist<CR>", "loclist" },
  r = { "<cmd>TroubleToggle lsp_references<CR>", "references" },
}
