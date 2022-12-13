-- Adpated from https://github.com/mrbeardad/MyLunarVim/blob/master/lua/user/alpha.lua

local M = {}

local artwork = require("user.artwork").random_headers()

M.config = function()
  lvim.builtin.alpha.active = true
  lvim.builtin.alpha.mode = "dashboard"
  lvim.builtin.alpha.dashboard.section.header = {
    type = "text",
    val = artwork,
    opts = {
      position = "center",
      hl = "Comment",
    },
  }
  local status_ok, dashboard = pcall(require, "alpha.themes.dashboard")
  if status_ok then
    local function button(sc, txt, keybind, keybind_opts)
      local b = dashboard.button(sc, txt, keybind, keybind_opts)
      b.opts.hl_shortcut = "Macro"
      return b
    end
    table.insert(
      lvim.builtin.alpha.dashboard.section.buttons.val,
      7,
      button("l", "  Restore Session", "<cmd>lua require('persistence').load()<cr>")
    )
  end
end

return M
