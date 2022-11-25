vim.g.VtrPercentage = 25
vim.g.VtrUseVtrMaps = 0

lvim.builtin.which_key.mappings["v"] = {
  name = "VTR",
  a = { "<cmd>VtrAttachToPane<CR>", "Attach" },
  k = { "<cmd>VtrKillRunner<CR>", "Kill" },
  f = { "<cmd>VtrFocusRunner<CR>", "Focus" },
}

-- vim-tmux-runner default mappings
-- nnoremap <leader>va :VtrAttachToPane<cr>
-- nnoremap <leader>ror :VtrReorientRunner<cr>
-- nnoremap <leader>sc :VtrSendCommandToRunner<cr>
-- nnoremap <leader>sl :VtrSendLinesToRunner<cr>
-- vnoremap <leader>sl :VtrSendLinesToRunner<cr>
-- nnoremap <leader>or :VtrOpenRunner<cr>
-- nnoremap <leader>kr :VtrKillRunner<cr>
-- nnoremap <leader>fr :VtrFocusRunner<cr>
-- nnoremap <leader>dr :VtrDetachRunner<cr>
-- nnoremap <leader>cr :VtrClearRunner<cr>
-- nnoremap <leader>fc :VtrFlushCommand<cr>
-- nnoremap <leader>sf :VtrSendFile<cr>
