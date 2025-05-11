require("lsp-progress").setup({
    client_format = function(client_name, spinner, series_messages)
        return #series_messages > 0
            and ("[" .. client_name .. "] " .. spinner .. " " .. table.concat(
                series_messages,
                ", "
            ))
            or nil
    end,

})

require("lualine").setup({
    sections = {
        lualine_c = { 'filename' },
        lualine_y = {
            -- Add LSP progress as a component
            function()
                return require("lsp-progress").progress()
            end,
        },
    },
    opts = function(_, opts)
        local trouble = require("trouble")
        local symbols = trouble.statusline({
            mode = "lsp_document_symbols",
            groups = {},
            title = false,
            filter = { range = true },
            format = "{kind_icon}{symbol.name:Normal}",
            hl_group = "lualine_c_normal",
        })
        table.insert(opts.sections.lualine_c, {
            symbols.get,
            cond = symbols.has,
        })
    end,
})

-- Refresh lualine when LSP progress updates
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
    group = "lualine_augroup",
    pattern = "LspProgressStatusUpdated",
    callback = require("lualine").refresh,
})
