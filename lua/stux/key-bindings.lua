local opts = { noremap = true, silent = true, buffer = bufnr }

vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, opts, { desc = "Open file explorer" })