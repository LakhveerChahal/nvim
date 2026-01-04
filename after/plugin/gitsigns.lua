require('gitsigns').setup{
    current_line_blame = true,
    on_attach = function(bufnr)
        local map = vim.keymap.set
        -- Actions
        map('n', '<leader>gs', ':Gitsigns stage_hunk<CR>', { buffer = bufnr, desc = 'Stage hunk' })
        map('n', '<leader>gr', ':Gitsigns reset_hunk<CR>', { buffer = bufnr, desc = 'Reset hunk' })
        map('n', '<leader>gk', ':Gitsigns prev_hunk<CR>', { buffer = bufnr, desc = 'Previous hunk' })
        map('n', '<leader>gj', ':Gitsigns next_hunk<CR>', { buffer = bufnr, desc = 'Next hunk' })
        
        map('n', '<leader>gS', ':Gitsigns stage_buffer<CR>', { buffer = bufnr, desc = 'Stage buffer' })
        map('n', '<leader>gR', ':Gitsigns reset_buffer<CR>', { buffer = bufnr, desc = 'Reset buffer' })
        map('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', { buffer = bufnr, desc = 'Preview hunk' })
        map('n', '<leader>gi', ':Gitsigns preview_hunk_inline<CR>', { buffer = bufnr, desc = 'Preview hunk inline' })

        -- Toggles
        map('n', '<leader>gb', ':Gitsigns toggle_current_line_blame<CR>', { buffer = bufnr, desc = 'Toggle blame' })
        map('n', '<leader>gd', ':Gitsigns toggle_deleted<CR>', { buffer = bufnr, desc = 'Toggle deleted' })
        map('n', '<leader>gw', ':Gitsigns toggle_word_diff<CR>', { buffer = bufnr, desc = 'Toggle word diff' })

    end
}
