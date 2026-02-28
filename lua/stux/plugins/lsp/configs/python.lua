local M = {}

function M.setup(capabilities)
    vim.lsp.config('pylsp', {
        capabilities = capabilities,
        settings = {
            pylsp = {
                plugins = {
                    pycodestyle = {
                        ignore = { "E501" },
                    },
                },
            },
        },
    })
end

return M
