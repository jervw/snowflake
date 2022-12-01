-- [[ keys.lua ]]
-- Keymap

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Leader key
vim.g.mapleader = " "

map('n', 'n', ':tabe ', {})

map('n', '<A-h>', ':BufferPrevious<CR>', opts)
map('n', '<A-l>', ':BufferNext<CR>', opts)
map('n', '<A-S-h>', ':BufferMovePrevious<CR>', opts)
map('n', '<A-S-l>', ':BufferMoveNext<CR>', opts)

-- Goto buffer in position...
map('n', '<A-1>', ':BufferGoto 1<CR>', opts)
map('n', '<A-2>', ':BufferGoto 2<CR>', opts)
map('n', '<A-3>', ':BufferGoto 3<CR>', opts)
map('n', '<A-4>', ':BufferGoto 4<CR>', opts)
map('n', '<A-5>', ':BufferGoto 5<CR>', opts)
map('n', '<A-6>', ':BufferGoto 6<CR>', opts)
map('n', '<A-7>', ':BufferGoto 7<CR>', opts)
map('n', '<A-8>', ':BufferGoto 8<CR>', opts)
map('n', '<A-9>', ':BufferGoto 9<CR>', opts)
map('n', '<A-0>', ':BufferLast<CR>', opts)

-- Close buffer
map('n', '<A-w>', ':BufferClose<CR>', opts)
map('n', '<A-n>', ':tabnew<CR>', opts)

-- Telescope
map('n', '<Leader>f', ':Telescope find_files<CR>', opts)
map('n', '<Leader>g', ':Telescope live_grep<CR>', opts)
map('n', '<Leader>b', ':Telescope buffers<CR>', opts)

-- Formatting
map('n', '<leader><leader>', ':Neoformat<CR>', opts)
