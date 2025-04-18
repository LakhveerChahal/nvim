require("mason").setup()

-- Mason-LSPConfig Setup
require("mason-lspconfig").setup({
    ensure_installed = { "angularls", "bashls", "html", "cssls" },
    automatic_installation = true,
})
