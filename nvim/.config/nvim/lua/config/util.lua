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

-- https://github.com/folke/dot/blob/1007fc65738ad1f7a3e9c91432430017a6878378/nvim/lua/util/init.lua#L125
function M.cowboy()
  ---@type table?
  local id
  local ok = true
  for _, key in ipairs({ "h", "j", "k", "l", "+", "-" }) do
    local count = 0
    local timer = assert((vim.uv or vim.loop).new_timer())
    local map = key
    vim.keymap.set("n", key, function()
      if vim.v.count > 0 then
        count = 0
      end
      if count >= 10 and vim.bo.buftype ~= "nofile" then
        ok, id = pcall(vim.notify, "Whoa there, Cowboy!", vim.log.levels.WARN, {
          icon = "🤠",
          replace = id,
          keep = function()
            return count >= 10
          end,
        })
        if not ok then
          id = nil
          return map
        end
      else
        count = count + 1
        timer:start(2000, 0, function()
          count = 0
        end)
        return map
      end
    end, { expr = true, silent = true })
  end
end

return M
