require('opts') -- Options
require('plug') -- Plugins
require('vars') -- Variables
require('keys') -- Keys


require('impatient')

-- PLUGINS: Add this section
require('nvim-tree').setup {}

require('lualine').setup {
    options = {
        theme = 'catppuccin'
    }
}

require('nvim-autopairs').setup {}

local lsp = require('lsp-zero')
lsp.preset('recommended')
lsp.nvim_workspace()
lsp.setup()
