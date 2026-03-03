-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local create_augroup = vim.api.nvim_create_augroup
local create_autocmd = vim.api.nvim_create_autocmd

-- Recognize Hugo layout HTML files as Go templates
vim.filetype.add({
  pattern = {
    [".*/layouts/.*%.html"] = "gotmpl",
  },
})

create_augroup("file_types", { clear = true })

create_autocmd("FileType", {
  desc = "Disable format-on-save for Hugo/Go template files",
  group = "file_types",
  pattern = "gotmpl",
  callback = function()
    vim.b.autoformat = false
  end,
})

create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  desc = "Recognize .gemrc as yaml",
  group = "file_types",
  pattern = { ".gemrc" },
  command = [[ set filetype=yaml ]],
})

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

-- create_autocmd({ "VimEnter" }, {
--   desc = "Go straight to INSERT mode in commit message",
--   group = "file_types",
--   pattern = { "COMMIT_EDITMSG" },
--   command = [[ exec 'norm gg' | startinsert! ]],
-- })
