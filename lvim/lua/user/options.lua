-- LunarVim default settings
-- https://github.com/LunarVim/LunarVim/blob/1.2.0/lua/lvim/config/settings.lua

vim.opt.cursorcolumn = false
vim.opt.relativenumber = true
vim.opt.shell = "/bin/bash -i" -- Needed since I use fish as main shell
vim.opt.list = true
vim.opt.listchars:append { tab = "»·" }
vim.opt.listchars:append { trail = "·" }
vim.opt.listchars:append { extends = "…" }
vim.opt.listchars:append { precedes = "…" }
vim.opt.listchars:append { nbsp = "+" }
