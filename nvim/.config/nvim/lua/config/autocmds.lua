-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local create_augroup = vim.api.nvim_create_augroup
local create_autocmd = vim.api.nvim_create_autocmd

create_augroup("file_types", { clear = true })

create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  desc = "Recognize mdx files as markdown",
  group = "file_types",
  pattern = { "*.mdx" },
  command = [[ set filetype=markdown ]],
})

create_autocmd("FileType", {
  desc = "Disable autocmd set filetype=eruby.yaml from rails.vim",
  group = "file_types",
  pattern = "eruby.yaml",
  command = [[set filetype=yaml]],
})

create_autocmd({ "VimEnter" }, {
  desc = "Go straight to INSERT mode in commit message",
  group = "file_types",
  pattern = { "COMMIT_EDITMSG" },
  command = [[ exec 'norm gg' | startinsert! ]],
})

create_autocmd({ "BufEnter", "Filetype" }, {
  desc = "Open mini.map and exclude some filetypes",
  pattern = { "*" },
  callback = function()
    local exclude_ft = {
      "NvimTree",
      "TelescopePrompt",
      "alpha",
      "dashboard",
      "lazy",
      "netrw",
      "qf",
      "toggleterm",
      "gitcommit",
    }

    local status_ok, map = pcall(require, "mini.map")
    if not status_ok then
      return
    end

    if vim.tbl_contains(exclude_ft, vim.o.filetype) then
      vim.b.minimap_disable = true
      map.close()
    elseif vim.o.buftype == "" then
      map.open()
    end
  end,
})
