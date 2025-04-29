require("mason").setup()

-- Mason-LSPConfig Setup
require("mason-lspconfig").setup({
    ensure_installed = { "gopls", "angularls@14.2.0", "bashls", "html", "cssls" },
    automatic_installation = true,
})
