require("mason").setup()

-- Mason-LSPConfig Setup
require("mason-lspconfig").setup({
    ensure_installed = { "gopls", "lua_ls", "angularls", "bashls", "html", "cssls", "pylsp" },
    automatic_installation = true,
})

require("mason-nvim-dap").setup({
    ensure_installed = { "python" },  -- This installs debugpy
    handlers = {},  -- Uses automatic setup for adapters
})
