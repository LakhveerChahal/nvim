-- LSP attach autocmd: keymaps + builtin completion
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local opts = { noremap = true, silent = true, buffer = ev.buf }

        -- Builtin autocompletion
        if client and client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })

            vim.keymap.set('i', '<C-Space>', function()
                vim.lsp.completion.get()
            end, opts)
        end

        -- Navigation (using Telescope)
        vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
        vim.keymap.set('n', 'gD', '<cmd>Telescope lsp_declarations<CR>', opts)
        vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts)
        vim.keymap.set('n', 'gt', '<cmd>Telescope lsp_type_definitions<CR>', opts)
        vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)

        -- Information
        vim.keymap.set('n', 'H', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>sh', vim.lsp.buf.signature_help, opts)

        -- Refactoring
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

        -- Diagnostics
        vim.keymap.set('n', '<leader>sd', vim.diagnostic.setqflist, opts)
        vim.keymap.set('n', '[e', function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end, opts)
        vim.keymap.set('n', ']e', function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end, opts)
        vim.keymap.set('n', '[w', function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN }) end, opts)
        vim.keymap.set('n', ']w', function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN }) end, opts)

    end,
})

-- Diagnostics configuration
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
})
