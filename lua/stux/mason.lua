require('mason').setup()

require("mason-lspconfig").setup({
	ensure_installed = { "jdtls", "angularls", "bashls" },
	automatic_installation = true,
})
require("mason-nvim-dap").setup({
	automatic_installation = true,
	handlers = {
		function(config)
			require("mason-nvim-dap").default_setup(config)
		end,
	},
})


-- After setting up mason-lspconfig you may set up servers via lspconfig
-- require("lspconfig").lua_ls.setup {}
-- require("lspconfig").rust_analyzer.setup {}
-- ...
