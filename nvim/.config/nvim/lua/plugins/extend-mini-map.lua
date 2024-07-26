-- Blazing fast minimap/scrollbar in Lua | https://github.com/echasnovski/mini.map/

return {
  {
    "echasnovski/mini.map",
    branch = "stable",
    config = function()
      require("mini.map").setup()
      local map = require("mini.map")
      map.setup({
        integrations = {
          map.gen_integration.builtin_search(),
          map.gen_integration.diagnostic({
            error = "DiagnosticFloatingError",
            warn = "DiagnosticFloatingWarn",
            info = "DiagnosticFloatingInfo",
            hint = "DiagnosticFloatingHint",
          }),
          map.gen_integration.gitsigns({
            add = "GitSignsAdd",
            change = "GitSignsChange",
            delete = "GitSignsDelete",
          }),
        },
        symbols = {
          encode = map.gen_encode_symbols.dot("3x2"),
        },
        window = {
          side = "right",
          width = 15, -- set to 1 for a pure scrollbar :)
          winblend = 15,
          show_integration_count = false,
        },
      })
    end,
  },
}
