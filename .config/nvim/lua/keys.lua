-- [[ keys.lua ]]

-- Leader key
local g = vim.g

g.leader = " "

local map = vim.api.nvim_set_keymap

-- Toggle nvim-tree
map('n', 'n', [[:NvimTreeToggle]], {})
