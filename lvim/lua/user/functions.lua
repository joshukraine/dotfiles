local M = {}

function M.toggle_option(option)
  local value = not vim.api.nvim_get_option_value(option, {})
  vim.opt[option] = value
  vim.notify(option .. " set to " .. tostring(value))
end

function M.toggle_colorcolumn()
  local value = vim.api.nvim_get_option_value("colorcolumn", {})

  if value == "81" then
    value = "0"
  else
    value = "81"
  end

  vim.opt.colorcolumn = value

  vim.notify("colorcolumn" .. " set to " .. tostring(value))
end

return M
