vim.opt_local.linebreak = true
vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"
vim.opt_local.textwidth = 0
vim.opt_local.wrap = true
vim.opt_local.wrapmargin = 0
vim.opt.conceallevel = 2
vim.g.asciidoctor_syntax_conceal = 1
vim.opt.complete:append("kspell")

vim.api.nvim_set_hl(0, "asciidoctorItalic", { italic = true, fg = "#bb9af7" })
vim.api.nvim_set_hl(0, "asciidoctorBold", { bold = true, fg = "#e0af68" })
