require("mason").setup()

-- Mason-LSPConfig Setup
require("mason-lspconfig").setup({
	ensure_installed = { "angularls", "bashls" },
	automatic_installation = true,
	handlers = {
		-- Default handler for other LSPs
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,
	},
})
