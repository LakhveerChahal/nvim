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
        lualine_c = {
            -- Add LSP progress as a component
            function()
                return require("lsp-progress").progress()
            end,
        },
    },
})

-- Refresh lualine when LSP progress updates
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
    group = "lualine_augroup",
    pattern = "LspProgressStatusUpdated",
    callback = require("lualine").refresh,
})
