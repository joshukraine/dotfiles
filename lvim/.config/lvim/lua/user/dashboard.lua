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
  table.insert(lvim.builtin.alpha.dashboard.section.buttons.entries, {
    "l",
    "󰁯  Restore Session",
    "<cmd>lua require('persistence').load()<cr>",
  })
end

return M
