-- [[ keys.lua ]]
-- Keymap

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

--- Replace ; with : to enter command mode without pressing shift
map("n", ";", ":", {})

vim.g.mapleader = " "

-- Split and navigation
map("n", "<leader>v", ":vsplit<CR><C-w>l", { desc = "Split vertically" })
map("n", "<leader>h", ":wincmd h<CR>", { desc = "Navigate left" })
map("n", "<leader>l", ":wincmd l<CR>", { desc = "Navigate right" })

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

local telescope = require("telescope.builtin")
vim.keymap.set("n", "n", telescope.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>?", telescope.oldfiles, { desc = "Recent files" })
vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "Find help" })
vim.keymap.set("n", "<leader>fw", telescope.grep_string, { desc = "Find word" })
vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "Find grep" })
vim.keymap.set("n", "<leader>fd", telescope.diagnostics, { desc = "Find diagnostics" })
vim.keymap.set("n", "<leader>fc", telescope.colorscheme, { desc = "Find colorschemes" })

-- Close buffer
map("n", "<A-w>", ":BufferClose<CR>", opts)
map("n", "<A-n>", ":tabnew<CR>", opts)

-- Git signs
map("n", "<leader>b", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Gitsigns blame" })
map("n", "<leader>s", ":Gitsigns toggle_signs<CR>", { desc = "Gitsigns toggle signs" })

-- Formatting
map("n", "<leader><leader>", ":Neoformat<CR>", { desc = "Format code" })

-- Copilot toggle
map("n", "<leader>o", ':lua require("copilot.suggestion").toggle_auto_trigger()<CR>', { desc = "Toggle copilot" })
