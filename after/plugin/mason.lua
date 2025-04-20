require("mason").setup()

-- Mason-LSPConfig Setup
require("mason-lspconfig").setup({
    ensure_installed = { "gopls", "angularls", "bashls", "html", "cssls" },
    automatic_installation = true,
})
