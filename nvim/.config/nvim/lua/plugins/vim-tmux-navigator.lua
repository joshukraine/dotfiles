-- https://github.com/christoomey/vim-tmux-navigator

return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    -- Normal mode navigation (default vim-tmux-navigator behavior)
    { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
    { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },

    -- Terminal mode navigation (enables navigation from terminal buffers)
    -- Critical for ClaudeCode.nvim and other terminal workflows
    { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", mode = "t" },
    { "<c-j>", "<cmd>TmuxNavigateDown<cr>", mode = "t" },
    { "<c-k>", "<cmd>TmuxNavigateUp<cr>", mode = "t" },
    { "<c-l>", "<cmd>TmuxNavigateRight<cr>", mode = "t" },
    { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>", mode = "t" },
  },
}
