-- https://www.lunarvim.org/docs/configuration/statusline

local components = require("lvim.core.lualine.components")

lvim.builtin.lualine.sections.lualine_c = {
  components.filename,
  components.diff,
}
