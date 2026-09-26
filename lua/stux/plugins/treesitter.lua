return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        -- Add nvim-treesitter runtime directory to runtimepath for queries
        local ts_path = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/runtime"
        vim.opt.rtp:prepend(ts_path)

        -- Use nvim-treesitter.configs for setup
        require("nvim-treesitter.configs").setup({
            -- Specify where to install the parsers
            parser_install_dir = vim.fn.stdpath("data") .. "/site",

            -- Parsers to install (async, no-op if already installed)
            ensure_installed = {
                "typescript",
                "python",
                "json",
                "bash",
                "html",
                "css",
                "yaml",
                "javascript",
                "go",
            },

            -- Automatically install missing parsers when entering buffer
            auto_install = true,

            -- Enable treesitter-based highlighting
            highlight = {
                enable = true,
            },

            -- Enable treesitter-based indentation
            indent = {
                enable = true,
            },
        })
    end,
}
