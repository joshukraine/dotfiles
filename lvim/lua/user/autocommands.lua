local create_autocmd = vim.api.nvim_create_autocmd
local create_augroup = vim.api.nvim_create_augroup

local yankGrp = create_augroup("YankHighlight", { clear = true })
create_autocmd("TextYankPost", {
  command = "silent! lua vim.highlight.on_yank()",
  group = yankGrp,
})

-- vim.cmd [[
--   autocmd BufRead,BufNewFile *.html.erb set filetype=eruby.html
-- ]]
