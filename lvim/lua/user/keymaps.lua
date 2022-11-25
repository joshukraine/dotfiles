-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

-- Remove key mappings that conflict with macOS
lvim.keys.normal_mode["<C-Up>"] = false
lvim.keys.normal_mode["<C-Down>"] = false
lvim.keys.normal_mode["<C-Left>"] = false
lvim.keys.normal_mode["<C-Right>"] = false

-- NORMAL mode ----------------------------------------------------------------
-- General
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<C-i>"] = ":set cursorcolumn!<CR>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<leader>ra"] = ":%s/"

-- Window sizing
lvim.keys.normal_mode["<Up>"] = ":resize +2<CR>"
lvim.keys.normal_mode["<Down>"] = ":resize -2<CR>"
lvim.keys.normal_mode["<Left>"] = ":vertical resize +2<CR>"
lvim.keys.normal_mode["<Right>"] = ":vertical resize -2<CR>"

-- INSERT mode ----------------------------------------------------------------
lvim.keys.insert_mode["jj"] = "<ESC>"

-- VISUAL mode ----------------------------------------------------------------
-- lvim.keys.visual_mode["p"] = "\"_dP"
