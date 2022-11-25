local options = {
  backup = false,
  clipboard = "unnamedplus",
  cmdheight = 1,
  cursorcolumn = false,
  cursorline = true,
  encoding = "utf-8",
  expandtab = true,
  hidden = true,
  ignorecase = true,
  lazyredraw = false,
  number = true,
  regexpengine = 1, -- Force vim to use older regex engine - https://stackoverflow.com/a/16920294/655204
  relativenumber = true,
  shiftwidth = 2,
  showcmd = true,
  showmode = true,
  smartcase = true,
  splitbelow = true,
  splitright = true,
  swapfile = false,
  tabstop = 2,
  wrap = false,
  writebackup = false,
  smarttab = true,
  shell = "/bin/bash -i", -- Needed since I use fish as main shell
  colorcolumn = "0",
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- vim.cmd [[set iskeyword+=-]]
vim.cmd [[set list listchars=tab:»·,trail:·,extends:>,precedes:<,nbsp:+]]
