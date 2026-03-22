return {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    config = function()
        vim.o.foldlevel = 99   -- Open all folds by default
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true -- Enable folding

        require('ufo').setup()
    end,
}
