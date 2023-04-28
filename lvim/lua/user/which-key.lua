lvim.builtin.which_key.mappings["1"] = { ":set cursorcolumn!<cr>", "CursorColumn" }
lvim.builtin.which_key.mappings["2"] = {
  "<cmd>lua require('user.functions').toggle_colorcolumn()<cr>",
  "ColorColumn",
}
lvim.builtin.which_key.mappings["3"] = {
  "<cmd>lua require('user.functions').toggle_option('relativenumber')<cr>",
  "RelativeNumber",
}
lvim.builtin.which_key.mappings["4"] = { "<C-^>", "Previous Buffer" }
lvim.builtin.which_key.mappings["5"] = {
  "<cmd>lua MiniMap.toggle()<cr>",
  "MiniMap",
}
lvim.builtin.which_key.mappings["6"] = {
  "<cmd>lua require('user.functions').toggle_option('wrap')<cr>",
  "Wrap",
}
lvim.builtin.which_key.mappings["7"] = {
  "<cmd>lua require('persistence').load()<cr>",
  "Restore Session",
}
lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
lvim.builtin.which_key.mappings["Q"] = { ":q<cr>", "Quit Window" }
lvim.builtin.which_key.mappings["q"] = { ":qa<cr>", "Quit All" }
lvim.builtin.which_key.mappings["b-"] = { ":wincmd _<cr>:wincmd |<cr>", "Zoom Window In" }
lvim.builtin.which_key.mappings["b="] = { ":wincmd =<cr>", "Balance Windows" }
lvim.builtin.which_key.mappings["sa"] = { ":%s/", "Replace" }

-- lvim.builtin.which_key.mappings["D"] = {
--   name = "Diagnostics",
--   t = { "<cmd>TroubleToggle<cr>", "trouble" },
--   w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
--   d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
--   q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
--   l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
--   r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
-- }

lvim.builtin.which_key.mappings["t"] = {
  name = "Test",
  n = { "<cmd>TestNearest<cr>", "Nearest" },
  f = { "<cmd>TestFile<cr>", "File" },
  s = { "<cmd>TestSuite<cr>", "Suite" },
  l = { "<cmd>TestLast<cr>", "Last" },
  g = { "<cmd>TestVisit<cr>", "Visit" },
}

lvim.builtin.which_key.mappings["v"] = {
  name = "VTR",
  a = { "<cmd>VtrAttachToPane<CR>", "Attach" },
  k = { "<cmd>VtrKillRunner<CR>", "Kill" },
  f = { "<cmd>VtrFocusRunner<CR>", "Focus" },
}
