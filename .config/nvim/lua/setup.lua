-- [[ plug.lua ]]
-- Plugin specific setup
require("nvim-autopairs").setup()
require("neoscroll").setup()
require("crates").setup()
require("gitsigns").setup()

-- Terminal configuration
require("toggleterm").setup{
	direction = "horizontal",
	size = 15,
	open_mapping = [[<M-j>]]
}

-- Copilot configuration
require("copilot").setup({
	suggestion = {
		enabled = true,
		auto_trigger = true,
		debounce = 75,
		keymap = {
			accept = "<M-e>",
			accept_word = false,
			accept_line = false,
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
	},
})

-- Tabline configuration
require("lualine").setup({
	options = {
		theme = "auto",
		section_separators = { left = "", right = "" },
		component_separators = { left = "", right = "" },
	},
})

-- Treesitter configuration
require("nvim-treesitter.configs").setup({
	highlight = {},
	rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = nil,
	},
	cpp = {
		file = {
			enable = true,
			priority = 1,
			parser = "cpp",
			conditions = {
				filetype = "cc",
			},
		},
	},
})
