-- https://github.com/reedes/vim-textobj-quote#configuration
local create_autocmd = vim.api.nvim_create_autocmd
local create_augroup = vim.api.nvim_create_augroup

local textobj_quote = create_augroup("textobj_quote", { clear = true })
create_autocmd("FileType", {
  group = textobj_quote,
  pattern = { "markdown", "textile" },
  callback = function()
    vim.fn["textobj#quote#init"]()
  end,
})
create_autocmd("FileType", {
  group = textobj_quote,
  pattern = { "text" },
  callback = function()
    vim.fn["textobj#quote#init"]({ educate = 0 })
  end,
})
