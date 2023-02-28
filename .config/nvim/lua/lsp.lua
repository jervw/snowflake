local lsp = require("lsp-zero")
lsp.preset("recommended")

lsp.set_preferences({
	suggest_lsp_servers = false,
	sign_icons = {
		error = "E",
		warn = "W",
		hint = "H",
		info = "I",
	},
})

lsp.nvim_workspace()
lsp.setup()

-- inline diagnostics
vim.diagnostic.config({
	virtual_text = true,
})
