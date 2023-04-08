-- Author: @jervw 
-- Description: My neovim config

-- OPTIONS
local opt = vim.opt
local cmd = vim.api.nvim_command
local g = vim.g

opt.tabstop = 4
opt.shiftwidth = 4
opt.autoindent = false
opt.smartindent = true
opt.expandtab = true
opt.rnu = true
opt.swapfile = false
opt.updatetime = 50
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.syntax = "ON"
opt.shell = "/bin/bash"
opt.udf = true

cmd("set noshowmode")

g.t_co = 256
g.background = "dark"
g.copilot_no_tab_map = true
cmd("colorscheme carbonfox")

opt.termguicolors = true

vim.diagnostic.config({
	virtual_text = true,
})

-- KEY MAPPINGS

local map = vim.api.nvim_set_keymap
local vmap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key
g.mapleader = " "

--- Replace ; with : to enter command mode without pressing shift
map("n", ";", ":", {})

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

-- Telescope
local telescope = require("telescope.builtin")
vmap("n", "<leader>?", telescope.oldfiles, { desc = "Recent files" })
vmap("n", "<leader>f", telescope.find_files, { desc = "Find files" })
vmap("n", "<leader>w", telescope.grep_string, { desc = "Find word" })
vmap("n", "<leader>g", telescope.live_grep, { desc = "Find grep" })
vmap("n", "<leader>d", telescope.diagnostics, { desc = "Find diagnostics" })

-- Gitsigns
map("n", "<leader>b", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Gitsigns blame" })
map("n", "<leader>s", ":Gitsigns toggle_signs<CR>", { desc = "Gitsigns toggle signs" })

-- Copilot toggle
map("n", "<leader>o", ':lua require("copilot.suggestion").toggle_auto_trigger()<CR>', { desc = "Toggle copilot" })







