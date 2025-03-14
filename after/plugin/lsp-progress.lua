require("lsp-progress").setup({
    -- Optional: Customize the spinner animation
    spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
    -- How long to show the last message after it’s done (in ms)
    decay = 1000,
    -- Format for each LSP client’s progress messages
    client_format = function(client_name, spinner, series_messages)
        if #series_messages == 0 then
            return nil
        end
        return client_name .. " " .. spinner .. " " .. table.concat(series_messages, ", ")
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
