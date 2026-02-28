return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local treesitter = require("nvim-treesitter")
        treesitter.setup({
            install_dir = vim.fn.stdpath("data") .. "/site",
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
        }
        })

        -- Enable treesitter-based highlighting
        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })
    end,
}
