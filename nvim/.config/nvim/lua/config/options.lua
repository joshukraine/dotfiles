-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.listchars:append({ extends = "…" })
vim.opt.listchars:append({ nbsp = "+" })
vim.opt.listchars:append({ precedes = "…" })
vim.opt.listchars:append({ tab = "·»" })
vim.opt.listchars:append({ trail = "·" })

-- LSP Ruby configuration
vim.g.lazyvim_ruby_lsp = "ruby_lsp"
vim.g.lazyvim_ruby_formatter = "standardrb"
