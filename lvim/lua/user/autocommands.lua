local create_autocmd = vim.api.nvim_create_autocmd
local create_augroup = vim.api.nvim_create_augroup

local yankGrp = create_augroup("YankHighlight", { clear = true })
create_autocmd("TextYankPost", {
  command = "silent! lua vim.highlight.on_yank()",
  group = yankGrp,
})


local fold_settings = create_augroup("fold_settings", { clear = true })
create_autocmd("FileType", {
  group = fold_settings,
  pattern = { "json", },
  command = [[ setlocal foldmethod=syntax ]],
})
create_autocmd("FileType", {
  group = fold_settings,
  pattern = { "json", },
  command = [[ normal zR ]],
})

local file_types = create_augroup("file_types", { clear = true })
create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  group = file_types,
  pattern = { "*.{prettierrc,stylelintrc,babelrc,eslintrc}", },
  command = [[ set filetype=json ]],
})
create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  group = file_types,
  pattern = { "gitconfig", },
  command = [[ set filetype=gitconfig ]],
})
create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  group = file_types,
  pattern = { "*.spv", },
  command = [[ set filetype=php ]],
})
create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  group = file_types,
  pattern = { "*.mdx", },
  command = [[ set filetype=markdown ]],
})
create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  group = file_types,
  pattern = { "{aliases,functions,prompt,tmux,oh-my-zsh,opts}", },
  command = [[ set filetype=zsh ]],
})
