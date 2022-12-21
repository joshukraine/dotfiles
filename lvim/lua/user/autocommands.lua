local create_augroup = vim.api.nvim_create_augroup
local create_autocmd = vim.api.nvim_create_autocmd

create_augroup("reload_config_on_save", {})
create_autocmd("BufWritePost", {
  group = "reload_config_on_save",
  pattern = os.getenv("HOME") .. "/dotfiles/**/*.lua", -- Allows for symlinked config
  desc = "Trigger LvimReload on saving config.lua",
  callback = function()
    require("lvim.config"):reload()
  end,
})

local yankGrp = create_augroup("YankHighlight", { clear = true })
create_autocmd("TextYankPost", {
  command = "silent! lua vim.highlight.on_yank()",
  group = yankGrp,
})

local fold_settings = create_augroup("fold_settings", { clear = true })
create_autocmd("FileType", {
  group = fold_settings,
  pattern = { "json" },
  command = [[ setlocal foldmethod=syntax ]],
})
create_autocmd("FileType", {
  group = fold_settings,
  pattern = { "json" },
  command = [[ normal zR ]],
})

local file_types = create_augroup("file_types", { clear = true })
create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  group = file_types,
  pattern = { "*.{prettierrc,stylelintrc,babelrc,eslintrc}" },
  command = [[ set filetype=json ]],
})
create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  group = file_types,
  pattern = { "gitconfig" },
  command = [[ set filetype=gitconfig ]],
})
create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  group = file_types,
  pattern = { "*.spv" },
  command = [[ set filetype=php ]],
})
create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  group = file_types,
  pattern = { "*.mdx" },
  command = [[ set filetype=markdown ]],
})
create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  group = file_types,
  pattern = { "{aliases,functions,prompt,tmux,oh-my-zsh,opts}" },
  command = [[ set filetype=zsh ]],
})

lvim.autocommands = {
  {
    { "BufEnter", "Filetype" },
    {
      desc = "Open mini.map and exclude some filetypes",
      pattern = { "*" },
      callback = function()
        local exclude_ft = {
          "qf",
          "NvimTree",
          "toggleterm",
          "TelescopePrompt",
          "alpha",
          "netrw",
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
    },
  },
}
