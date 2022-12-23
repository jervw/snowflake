-- [[ plug.lua ]]
-- Plugin specific setup
require("catppuccin").setup()
require("lualine").setup({ options = { theme = "catppuccin" } })
require("nvim-autopairs").setup()
require("neoscroll").setup()
require("nvim-tree").setup()

-- Copilot configuration
require("copilot").setup {
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
}

-- Treesitter configuration
require("nvim-treesitter.configs").setup({
	highlight = {},
	rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = nil,
	},
})
