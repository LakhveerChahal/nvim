vim.wo.relativenumber = true
vim.wo.number = true

-- Global settings for Neovim 0.11
vim.o.completeopt = 'menuone,noinsert,popup,fuzzy'

require("stux")

-- Enable LSP servers (configs are in lsp/*.lua)
vim.lsp.enable({ 'gopls', 'pylsp', 'ts_ls', 'angularls', 'html', 'cssls', 'lua_ls' })
