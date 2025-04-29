-- Dans typescript.lua
local M = {}

function M.setup(capabilities)
  require("typescript-tools").setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      vim.keymap.set("n", "gd", "<cmd>TSToolsGoToSourceDefinition<cr>", { buffer = bufnr })
      vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { buffer = bufnr })
      vim.keymap.set("n", "K", "<cmd>TSToolsHover<cr>", { buffer = bufnr })
      vim.keymap.set("n", "<leader>ca", "<cmd>TSToolsFixAll<cr>", { buffer = bufnr })
      vim.keymap.set("n", "<leader>rn", "<cmd>TSToolsRename<cr>", { buffer = bufnr })
      vim.keymap.set("n", "<leader>o", "<cmd>TSToolsOrganizeImports<cr>", { buffer = bufnr })

      -- Optimize imports on save
      vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = "*.ts,*.tsx",
          callback = function()
              vim.cmd("TSToolsOrganizeImports")
          end,
      })
    end,
    settings = {
      complete_function_calls = true,
      include_completions_with_insert_text = true,
      tsserver_plugins = {},
      tsserver_max_memory = "auto",
      tsserver_format_options = {
        allowIncompleteCompletions = true,
        allowRenameOfImportPath = true,
      },
    }
  })
end

return M
