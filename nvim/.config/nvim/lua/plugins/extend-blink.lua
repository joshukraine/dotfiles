-- Enhanced blink.cmp configuration that extends LazyVim defaults
-- Adds fuzzy matching optimizations, buffer performance tuning, and emoji completions

return {
  "saghen/blink.cmp",
  dependencies = {
    -- Emoji completions for markdown and documentation
    "moyiz/blink-emoji.nvim",
  },
  opts = function(_, opts)
    -- 1. Performance optimization - disable in file pickers and prompts
    opts.enabled = function()
      local disabled_filetypes = {
        "snacks_picker_input", -- Snacks.nvim input prompt
        "TelescopePrompt", -- Telescope prompt (future-proofing)
        "minifiles", -- MiniFiles picker
      }
      return not vim.tbl_contains(disabled_filetypes, vim.bo.filetype)
    end

    -- 2. LazyVim's keymap configuration is comprehensive (no overrides needed)
    -- Uses "enter" preset with additional LazyVim customizations
    -- Reference: https://www.lazyvim.org/extras/coding/blink

    -- 3. Visual customizations for a cleaner UI
    opts.appearance = vim.tbl_deep_extend("force", opts.appearance or {}, {
      -- Use 'mono' for Nerd Font Mono (ensures proper icon alignment)
      nerd_font_variant = "mono",
    })

    -- 4. Completion menu visual settings
    opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
      menu = {
        -- Rounded borders for a modern look
        border = "rounded",
        winblend = 0,
        winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",

        -- Menu dimensions
        min_width = 15,
        max_height = 10,
      },

      -- Documentation window
      documentation = {
        window = {
          border = "rounded",
          max_width = 80,
          max_height = 20,
          winblend = 0,
        },
      },
    })

    -- 5. Enhanced fuzzy matching configuration
    opts.fuzzy = vim.tbl_deep_extend("force", opts.fuzzy or {}, {
      sorts = { "score", "sort_text" }, -- Optimize completion ranking
    })

    -- 6. Disable cmdline ghost text and auto-show to prevent command interference
    opts.cmdline = vim.tbl_deep_extend("force", opts.cmdline or {}, {
      completion = {
        menu = {
          auto_show = false,
        },
        ghost_text = {
          enabled = false,
        },
      },
    })

    -- 7. Signature help window styling
    opts.signature = vim.tbl_deep_extend("force", opts.signature or {}, {
      window = {
        border = "rounded",
        max_height = 10,
        winblend = 0,
        winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
      },
    })

    -- 8. Enhanced completion sources with Copilot and emoji support
    opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
      default = { "lsp", "path", "snippets", "buffer", "copilot", "emoji" },
      providers = {
        -- Buffer completions with performance optimizations only
        buffer = {
          min_keyword_length = 2, -- Avoid single-character noise
          max_items = 8, -- Limit buffer results to avoid overwhelming menu
        },

        -- Emoji completions for markdown and documentation
        emoji = {
          module = "blink-emoji",
          name = "Emoji",
          score_offset = 15, -- Lower priority than code completions
          min_keyword_length = 2, -- Start after typing ":s" for ":smile:"
          opts = {
            insert = true, -- Insert emoji character vs completing the name
          },
        },
      },
    })

    return opts
  end,
}
