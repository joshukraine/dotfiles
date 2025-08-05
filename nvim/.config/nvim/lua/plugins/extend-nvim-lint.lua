-- Adapted from https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/plugins/nvim-lint.lua

return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        args = { "--config", os.getenv("HOME") .. "/.markdownlint-cli2.yaml", "--" },
      },
    },
  },
}
