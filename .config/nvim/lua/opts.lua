--[[ opts.lua ]]
local opt = vim.opt
local cmd = vim.api.nvim_command
local g = vim.g

-- Options
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

-- Theme
g.t_co = 256
g.background = "dark"
cmd("colorscheme duskfox")

opt.termguicolors = true

g.copilot_no_tab_map = true
