require('gitsigns').setup{
    current_line_blame = true,
    on_attach = function(bufnr)
        -- Actions
        map('n', '<leader>hs', ':Gitsigns stage_hunk<CR>', { buffer = bufnr, desc = 'Stage hunk' })
        map('n', '<leader>hr', ':Gitsigns reset_hunk<CR>', { buffer = bufnr, desc = 'Reset hunk' })
        
        map('n', '<leader>hS', ':Gitsigns stage_buffer<CR>', { buffer = bufnr, desc = 'Stage buffer' })
        map('n', '<leader>hR', ':Gitsigns reset_buffer<CR>', { buffer = bufnr, desc = 'Reset buffer' })
        map('n', '<leader>hp', ':Gitsigns preview_hunk<CR>', { buffer = bufnr, desc = 'Preview hunk' })
        map('n', '<leader>hi', ':Gitsigns preview_hunk_inline<CR>', { buffer = bufnr, desc = 'Preview hunk inline' })

        -- Toggles
        map('n', '<leader>tb', ':Gitsigns toggle_current_line_blame<CR>', { buffer = bufnr, desc = 'Toggle blame' })
        map('n', '<leader>td', ':Gitsigns toggle_deleted<CR>', { buffer = bufnr, desc = 'Toggle deleted' })
        map('n', '<leader>tw', ':Gitsigns toggle_word_diff<CR>', { buffer = bufnr, desc = 'Toggle word diff' })

    end
}
