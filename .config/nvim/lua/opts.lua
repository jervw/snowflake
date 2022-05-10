--[[ opts.lua ]]
local opt = vim.opt
local cmd = vim.api.nvim_command

-- Options
opt.tabstop = 4
opt.shiftwidth = 4
opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.number = true
opt.relativenumber = true
opt.ruler = true
opt.mouse = 'a'
opt.clipboard = 'unnamedplus'

-- Theme
opt.syntax = "ON"
opt.termguicolors = true
cmd('colorscheme catppuccin')
