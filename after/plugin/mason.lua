require("mason").setup()

-- Mason-LSPConfig Setup
require("mason-lspconfig").setup({
    ensure_installed = { "angularls", "bashls" },
    automatic_installation = true,
})
