vim.cmd [[let test#strategy = 'vtr']]

lvim.builtin.which_key.mappings["t"] = {
  name = "Test",
  n = { "<cmd>TestNearest<cr>", "Nearest" },
  f = { "<cmd>TestFile<cr>", "File" },
  s = { "<cmd>TestSuite<cr>", "Suite" },
  l = { "<cmd>TestLast<cr>", "Last" },
  g = { "<cmd>TestVisit<cr>", "Visit" },
}
