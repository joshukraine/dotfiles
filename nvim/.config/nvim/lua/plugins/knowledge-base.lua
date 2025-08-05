-- LazyVim Knowledge Base Search Plugin
-- Copy this file to ~/.config/nvim/lua/plugins/knowledge-base.lua

-- Cache for Marked 2 availability to avoid repeated system calls
local marked2_available = nil

-- Check if Marked 2 is available (cached)
local function is_marked2_available()
  if marked2_available == nil then
    local marked_check = vim.fn.system("osascript -e 'exists application \"Marked 2\"'")
    marked2_available = not marked_check:match("false")
  end
  return marked2_available
end

return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        knowledge_base = {
          name = "Knowledge Base",
          finder = function()
            local files = {}
            -- Use configurable path with fallback to default
            local kb_path = vim.g.knowledge_base_path or "~/personal-knowledge-base"
            kb_path = vim.fn.expand(kb_path)
            local md_files = {}
            if vim.fs and vim.fs.find then
              -- Use vim.fs.find if available (Neovim 0.9+)
              md_files = vim.fs.find(function(name)
                return name:match("%.md$")
              end, { path = kb_path, type = "file", limit = math.huge })
            else
              -- Fallback to vim.fn.glob for older Neovim
              md_files = vim.fn.glob(kb_path .. "/**/*.md", true, true)
            end
            for _, line in ipairs(md_files) do
              local relative_path = line:gsub(kb_path .. "/", "")
              table.insert(files, {
                text = vim.fn.fnamemodify(line, ":t:r"),
                file = line,
                display = relative_path,
              })
            end
            return files
          end,
          confirm = function(picker, item)
            picker:close()
            vim.cmd("edit " .. item.file)
          end,
          actions = {
            open_marked = function(picker, item)
              if not item then
                return
              end
              picker:close()

              -- Use cached Marked 2 availability check
              if not is_marked2_available() then
                vim.notify("Marked 2 not found. Install from Mac App Store.", vim.log.levels.WARN)
                return
              end

              vim.system({ "open", "-a", "Marked 2", item.file })
              vim.notify("Opened in Marked 2: " .. item.text)
            end,
            open_multiple_marked = function(picker)
              -- Get selected items with fallback to current item
              local items = picker:selected({ fallback = true })
              picker:close()

              -- Use cached Marked 2 availability check
              if not is_marked2_available() then
                vim.notify("Marked 2 not found. Install from Mac App Store.", vim.log.levels.WARN)
                return
              end

              -- Open each file in Marked 2
              for _, item in ipairs(items) do
                vim.system({ "open", "-a", "Marked 2", item.file })
              end
              vim.notify(string.format("Opened %d files in Marked 2", #items))
            end,
          },
          win = {
            input = {
              keys = {
                ["<C-o>"] = { "open_marked", mode = { "n", "i" } },
                ["<C-l>"] = { "open_multiple_marked", mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
  },
  keys = {
    {
      "<leader>fk",
      function()
        Snacks.picker.pick("knowledge_base")
      end,
      desc = "Knowledge Base",
    },
  },
}
