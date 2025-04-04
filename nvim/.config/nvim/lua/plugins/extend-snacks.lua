-- Uncomment the conditional to disable this config.
-- stylua: ignore
-- if true then return {} end

return {
  "folke/snacks.nvim",
  keys = {
    -- Always open picker at project root
    { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
  },
  opts = {
    picker = {
      hidden = true,
      sources = {
        -- These define their own options, we must override their defaults.
        files = { hidden = true },
        buffers = { hidden = true },
        -- Explorer and the rest of the sources don't define their own opts
        -- so it will use the picker options defined above and we can choose
        -- to override them if desired.
        explorer = { ignored = true },
      },
    },
  },
}

-- Reference:
-- https://www.reddit.com/r/neovim/comments/1ittmg3/hidden_files_in_lazyvim/
-- https://github.com/nickjj/dotfiles/blob/99713e0f5011cfbf934c9bd51cfffc1498b35431/.config/nvim/lua/plugins/snacks.lua
