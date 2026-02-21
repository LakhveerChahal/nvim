return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "nvim-lua/plenary.nvim",
            "L3MON4D3/LuaSnip"
        },
        config = function()

            require("stux.plugins.lsp.configs.angular").setup()
            require("stux.plugins.lsp.configs.go")
        end
    }
}
