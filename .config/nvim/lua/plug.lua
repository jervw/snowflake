-- [[ packer.lua ]]

vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- Self
	use("wbthomason/packer.nvim")
	-- Blazingly fast nvim
	use("lewis6991/impatient.nvim")

	-- Code completion
	use({
		"VonHeikemen/lsp-zero.nvim",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		},
	})
	-- Copilot
	use("zbirenbaum/copilot.lua")
	-- Rust crates
	use({ "saecki/crates.nvim", requires = { "nvim-lua/plenary.nvim" } })
	-- Tree shitter
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	-- Auto close brackets
	use("windwp/nvim-autopairs")
	-- Icons
	use("nvim-tree/nvim-web-devicons")
	-- Statusline
	use("nvim-lualine/lualine.nvim")
	-- File explorer
	use("nvim-tree/nvim-tree.lua")
	-- Colorscheme
	use({ "catppuccin/nvim", as = "catppuccin" })
	-- Tabline
	use("romgrk/barbar.nvim")
	-- Smoothscroll
	use("karb94/neoscroll.nvim")
	-- Formatting
	use("sbdchd/neoformat")
	-- Rainbow brackets
	use("p00f/nvim-ts-rainbow")
    -- Git decorations
    use("lewis6991/gitsigns.nvim")
end)
