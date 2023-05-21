vim.opt_local.linebreak = true
vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"
vim.opt_local.textwidth = 0
vim.opt_local.wrap = true
vim.opt_local.wrapmargin = 0
vim.opt.conceallevel = 0
vim.opt.complete:append("kspell")

vim.api.nvim_set_hl(0, "markdownItalic", { italic = true, fg = "#bb9af7" })
vim.api.nvim_set_hl(0, "markdownBold", { bold = true, fg = "#e0af68" })

vim.cmd([[
  inoremap <buffer> --<space> –<space>
  inoremap <buffer> ---<space> —<space>
]])
