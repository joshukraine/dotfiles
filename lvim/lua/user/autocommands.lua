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

create_augroup("YankHighlight", { clear = true })
create_autocmd("TextYankPost", {
  command = "silent! lua vim.highlight.on_yank()",
  group = "YankHighlight",
})

create_augroup("fold_settings", { clear = true })
create_autocmd("FileType", {
  group = "fold_settings",
  pattern = { "json" },
  command = [[ setlocal foldmethod=syntax ]],
})
create_autocmd("FileType", {
  group = "fold_settings",
  pattern = { "json" },
  command = [[ normal zR ]],
})

create_augroup("file_types", { clear = true })
create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  group = "file_types",
  pattern = { "*.{prettierrc,stylelintrc,babelrc,eslintrc}" },
  command = [[ set filetype=json ]],
})
create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  group = "file_types",
  pattern = { "gitconfig" },
  command = [[ set filetype=gitconfig ]],
})
create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  group = "file_types",
  pattern = { "*.spv" },
  command = [[ set filetype=php ]],
})
create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  group = "file_types",
  pattern = { "*.mdx" },
  command = [[ set filetype=markdown ]],
})
create_autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  group = "file_types",
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
  {
    { "ColorScheme" },
    {
      desc = "Set custom highlights",
      pattern = { "*" },
      callback = function()
        vim.api.nvim_set_hl(0, "ColorColumn", { link = "Search" })
        vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#98be65" })
        vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#7aa2f7" })
        vim.api.nvim_set_hl(0, "IlluminatedWord", { link = "CursorLine" })
        vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "CursorLine" })
        vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "CursorLine" })
        vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "CursorLine" })
      end,
    },
  },
}
