local M = {}

function M.setup()
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
            local opts = { noremap = true, silent = true, buffer = bufnr }

            -- Navigation
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts, { desc = "Go to declaration" })
            vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts, { desc = "Go to implementation" })
            vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts, { desc = "Go to type definition" })
            vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts, { desc = "Find references" })
            vim.keymap.set('n', '<leader>pd', '<cmd>lua vim.lsp.buf.peek_definition()<CR>', opts, { desc = "Peek definition" })

            -- Information
            vim.keymap.set('n', 'H', '<cmd>lua vim.lsp.buf.hover()<CR>', opts, { desc = "Show hover documentation" })
            vim.keymap.set('n', '<C-i>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts, { desc = "Show signature help" })

            -- Refactoring
            vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts, { desc = "Rename symbol" })
            vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts, { desc = "Code action" })

            -- Diagnostics
            vim.diagnostic.config({
                jump = {
                    on_jump = function(diagnostic)
                        -- Custom logic here, like opening a float with specific borders
                        vim.diagnostic.open_float({ focus = false })
                    end,
                },
            })
            vim.keymap.set('n', '<leader>sd', '<cmd>lua vim.diagnostic.setqflist()<CR>', opts, { desc = "Show diagnostics" })
            -- vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }); vim.schedule(vim.diagnostic.open_float) end, opts, { desc = "Previous diagnostic" })
            -- vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }); vim.schedule(vim.diagnostic.open_float) end, opts, { desc = "Next diagnostic" })
        end
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    return capabilities
end

return M
