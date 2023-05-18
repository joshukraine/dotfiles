-- LunarVim default settings
-- https://github.com/LunarVim/LunarVim/blob/1.2.0/lua/lvim/config/settings.lua
--
-- See :h option-list for more available options

vim.opt.list = true
vim.opt.listchars:append({ extends = "…" })
vim.opt.listchars:append({ nbsp = "+" })
vim.opt.listchars:append({ precedes = "…" })
vim.opt.listchars:append({ tab = "»·" })
vim.opt.listchars:append({ trail = "·" })
vim.opt.relativenumber = true
vim.opt.shell = "/bin/bash -i" -- Needed since I use fish as my main shell
vim.opt.regexpengine = 1
-- vim.opt.colorcolumn = "81"

-- vim-test
vim.g["test#strategy"] = "vtr"

-- vim-tmux-runner
vim.g["VtrPercentage"] = 25
vim.g["VtrUseVtrMaps"] = 0
