-- [[ keys.lua ]]
-- Keymap

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Replace ; with : to enter command mode without pressing shift
map("n", ";", ":", {})

-- Leader key
vim.g.mapleader = " "

map("n", "n", ":NvimTreeToggle<CR>", {})

map("n", "<A-,>", ":BufferPrevious<CR>", opts)
map("n", "<A-.>", ":BufferNext<CR>", opts)
map("n", "<A-S-,>", ":BufferMovePrevious<CR>", opts)
map("n", "<A-S-.>", ":BufferMoveNext<CR>", opts)

-- Goto buffer in position...
map("n", "<A-1>", ":BufferGoto 1<CR>", opts)
map("n", "<A-2>", ":BufferGoto 2<CR>", opts)
map("n", "<A-3>", ":BufferGoto 3<CR>", opts)
map("n", "<A-4>", ":BufferGoto 4<CR>", opts)
map("n", "<A-5>", ":BufferGoto 5<CR>", opts)
map("n", "<A-6>", ":BufferGoto 6<CR>", opts)
map("n", "<A-7>", ":BufferGoto 7<CR>", opts)
map("n", "<A-8>", ":BufferGoto 8<CR>", opts)
map("n", "<A-9>", ":BufferGoto 9<CR>", opts)
map("n", "<A-0>", ":BufferLast<CR>", opts)

-- Close buffer
map("n", "<A-w>", ":BufferClose<CR>", opts)
map("n", "<A-n>", ":tabnew<CR>", opts)

-- Zen mode
map("n", "<leader>f", ":ZenMode<CR>", opts)

-- Formatting
map("n", "<leader><leader>", ":Neoformat<CR>", opts)

-- Copilot toggle
map("n", "<leader>o", ':lua require("copilot.suggestion").toggle_auto_trigger()<CR>', opts)
