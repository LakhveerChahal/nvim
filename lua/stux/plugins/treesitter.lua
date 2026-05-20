return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        -- Add nvim-treesitter runtime directory to runtimepath for queries
        local ts_path = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/runtime"
        vim.opt.rtp:prepend(ts_path)

        require("nvim-treesitter").setup({
            install_dir = vim.fn.stdpath("data") .. "/site",
        })

        -- Install parsers (async, no-op if already installed)
        require("nvim-treesitter").install({
            "typescript",
            "python",
            "json",
            "bash",
            "html",
            "css",
            "yaml",
            "javascript",
            "go",
            "kotlin",
        })

        -- Enable treesitter-based highlighting
        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })
    end,
}
