--[[ opts.lua ]]
local opt = vim.opt
local cmd = vim.api.nvim_command
local g = vim.g

-- Options
opt.tabstop = 4
opt.shiftwidth = 4
opt.autoindent = false --experimenting
opt.smartindent = true
opt.expandtab = true
opt.number = true
opt.nu = true
opt.relativenumber = true
opt.swapfile = false
opt.updatetime = 50
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.shell = "/bin/bash"
opt.udf = true

cmd("set noshowmode")
cmd("abb WQ wq")
cmd("abb Wq wq")

-- Theme
g.t_co = 256
g.background = "dark"
g.catppuccin_flavour = "mocha"

g.copilot_no_tab_map = true

opt.syntax = "ON"
opt.termguicolors = true
cmd("colorscheme catppuccin")

-- Update the packer path
local packer_path = vim.fn.stdpath("config") .. "/site"
vim.o.packpath = vim.o.packpath .. "," .. packer_path
