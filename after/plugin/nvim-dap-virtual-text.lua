require("nvim-dap-virtual-text").setup({
    enabled = true, -- enable this plugin (the default)
    enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter does not support this)
    highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    show_stop_reason = true, -- show stop reason when stopped for exceptions
    commented = false, -- prefix virtual text with comment string
    virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',
})
