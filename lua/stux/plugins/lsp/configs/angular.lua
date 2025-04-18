local util = require('lspconfig.util')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.angularls.setup{
    capabilities = capabilities,
    settings = {
        angular = {
          enable = true,
          trace = {
            server = "messages"
          },
          diagnostics = {
            enable = true,
            templateErrors = true,
          },
          suggest = {
            fromTripleSlashReference = true,
            completeFunctionCalls = true,
          },
          format = {
            enable = true,
            insertSpaceAfterCommaDelimiter = true,
            insertSpaceAfterSemicolonInForStatements = true,
            insertSpaceBeforeAndAfterBinaryOperators = true,
            insertSpaceAfterKeywordsInControlFlowStatements = true,
            insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
            insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
            placeOpenBraceOnNewLineForFunctions = false,
            placeOpenBraceOnNewLineForControlBlocks = false,
          },
        }
    },
    filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
    on_attach = function(client, bufnr)
        -- Keymaps spécifiques à Angular
        local opts = { buffer = bufnr }
        vim.keymap.set("n", "<leader>at", ":AngularGoToTemplateForComponent<CR>", opts)
        vim.keymap.set("n", "<leader>ac", ":AngularGoToComponentWithTemplateFile<CR>", opts)
        vim.keymap.set("n", "<leader>as", ":AngularGoToSpec<CR>", opts)
        vim.keymap.set("n", "<leader>ag", ":AngularGoToDefinition<CR>", opts)
    end,
    root_dir = util.root_pattern("angular.json", "package.json")
}

