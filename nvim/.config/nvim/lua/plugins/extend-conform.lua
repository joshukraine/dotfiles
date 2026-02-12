-- https://github.com/folke/dot/blob/master/nvim/lua/plugins/lsp.lua

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
      },
      formatters_by_ft = {
        eruby = {},
      },
    },
  },
}
