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

function M.get_lvim_config_path()
  local pattern = get_config_dir():gsub("\\", "/") .. "/*.lua"
  local linked_config_lua = vim.fn.resolve(join_paths(get_config_dir(), "config.lua"))
  if linked_config_lua ~= join_paths(get_config_dir(), "config.lua") then
    local linked_config_dir = linked_config_lua:sub(1, #linked_config_lua - #"config.lua")
    pattern = pattern .. "," .. linked_config_dir:gsub("\\", "/") .. "*.lua"
  end
  return pattern
end

return M
