-- [[ plug.lua ]]
-- Plugin specific setup 

local api = vim.api

require('nvim-tree').setup()
require("catppuccin").setup()
require('lualine').setup {options = {theme = 'catppuccin'}}
require('nvim-autopairs').setup()
require("scrollbar").setup()
require('neoscroll').setup()



-- Tabline configuration
api.nvim_create_autocmd('BufWinEnter', {
	pattern = '*',
	callback = function()
		if vim.bo.filetype == 'NvimTree' then
			require'bufferline.state'.set_offset(31, 'FileTree')
		end
	end
})
api.nvim_create_autocmd('BufWinLeave', {
	pattern = '*',
	callback = function()
		if vim.fn.expand('<afile>'):match('NvimTree') then
			require'bufferline.state'.set_offset(0)
		end
	end
})
