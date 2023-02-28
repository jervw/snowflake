-- [[ plug.lua ]]
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v1.x",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },

			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		},
	},

	{ "saecki/crates.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

	"lewis6991/impatient.nvim", -- Speed up startup
	"zbirenbaum/copilot.lua", -- copilot
	"nvim-treesitter/nvim-treesitter", -- Treesitter
	"windwp/nvim-autopairs", -- Auto close brackets
	"nvim-tree/nvim-web-devicons", -- Icons
	"nvim-lualine/lualine.nvim", -- Statusline
	"nvim-tree/nvim-tree.lua", -- File explorer
	"romgrk/barbar.nvim", -- Tabs
	"karb94/neoscroll.nvim", -- Smoothscroll
	"sbdchd/neoformat", -- Format code
	"p00f/nvim-ts-rainbow", -- Rainbow brackets
	"lewis6991/gitsigns.nvim", -- Git decorations
    "EdenEast/nightfox.nvim", -- Colorscheme
})
