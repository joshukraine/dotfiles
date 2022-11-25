lvim.builtin.which_key.mappings["1"] = { ":Obsession<CR>", "Toggle Session" }
lvim.builtin.which_key.mappings["4"] = { "<C-^>", "Previous Buffer" }
lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
lvim.builtin.which_key.mappings["b-"] = { ":wincmd _<CR>:wincmd |<CR>", "Zoom Window In" }
lvim.builtin.which_key.mappings["b="] = { ":wincmd =<CR>", "Balance Windows" }

lvim.builtin.which_key.mappings["t"] = {
  name = "Diagnostics",
  t = { "<cmd>TroubleToggle<cr>", "trouble" },
  w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
  d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
  q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
  l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
  r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
}
