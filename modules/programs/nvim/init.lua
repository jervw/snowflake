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
opt.udf = true
opt.showmode = false

g.t_co = 256
g.background = "dark"
cmd("colorscheme carbonfox")

opt.termguicolors = true

-- LSP
local lsp = require('lsp-zero')
lsp.preset({
    name = 'recommended',
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I',
    },
})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

-- List LSP servers here
lsp.setup_servers({'rust_analyzer', 'lua_ls', 'rnix', 'pyright'})

lsp.setup()

-- Formatting and linting
local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.rustfmt,
    null_ls.builtins.formatting.nixpkgs_fmt,
  }
})

-- Inline diagnostics
vim.diagnostic.config({
    virtual_text = {
        prefix = '',
    },
})

-- KEY MAPPINGS

local map = vim.api.nvim_set_keymap
local vmap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key
g.mapleader = " "

--- Replace ; with : to enter command mode without pressing shift
map("n", ";", ":", {})

map("n", "<A-,>", ":BufferPrevious<CR>", opts)
map("n", "<A-.>", ":BufferNext<CR>", opts)
map("n", "<A-S-,>", ":BufferMovePrevious<CR>", opts)
map("n", "<A-S-.>", ":BufferMoveNext<CR>", opts)

-- Buffers
map("n", "<A-w>", ":BufferClose<CR>", opts)
map("n", "<A-n>", ":tabnew<CR>", opts)

-- Goto buffer in position...
map("n", "<A-1>", ":BufferGoto 1<CR>", opts)
map("n", "<A-2>", ":BufferGoto 2<CR>", opts)
map("n", "<A-3>", ":BufferGoto 3<CR>", opts)
map("n", "<A-4>", ":BufferGoto 5<CR>", opts)
map("n", "<A-5>", ":BufferGoto 5<CR>", opts)
map("n", "<A-6>", ":BufferGoto 6<CR>", opts)
map("n", "<A-7>", ":BufferGoto 7<CR>", opts)
map("n", "<A-8>", ":BufferGoto 8<CR>", opts)
map("n", "<A-9>", ":BufferGoto 9<CR>", opts)

-- Format document
map("n", "<leader><leader>", ":LspZeroFormat!<CR>", opts)

-- Telescope
local telescope = require("telescope.builtin")
vmap("n", "<leader>?", telescope.oldfiles, opts)
vmap("n", "<leader>f", telescope.find_files, opts)
vmap("n", "<leader>w", telescope.grep_string, opts)
vmap("n", "<leader>g", telescope.live_grep, opts)
vmap("n", "<leader>d", telescope.diagnostics, opts)

-- Gitsigns
map("n", "<leader>b", ":Gitsigns toggle_current_line_blame<CR>", opts)
map("n", "<leader>s", ":Gitsigns toggle_signs<CR>", opts)

-- Copilot toggle
map("n", "<leader>o", ':lua require("copilot.suggestion").toggle_auto_trigger()<CR>', opts)
