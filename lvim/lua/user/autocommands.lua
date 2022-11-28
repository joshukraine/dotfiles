local create_autocmd = vim.api.nvim_create_autocmd
local create_augroup = vim.api.nvim_create_augroup

local yankGrp = create_augroup("YankHighlight", { clear = true })
create_autocmd("TextYankPost", {
  command = "silent! lua vim.highlight.on_yank()",
  group = yankGrp,
})


local textobj_quote = create_augroup("textobj_quote", { clear = true })
create_autocmd("FileType", {
  group = textobj_quote,
  pattern = { "markdown", "textile" },
  callback = function()
    vim.fn["textobj#quote#init"]()
  end
})
