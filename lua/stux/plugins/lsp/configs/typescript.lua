-- Dans typescript.lua
local M = {}

-- Create augroup ONCE at module load (prevents duplicate autocmds)
local organize_imports_group = vim.api.nvim_create_augroup("TSOrganizeImportsOnSave", { clear = true })

function M.setup(capabilities)
  -- Create autocmd ONCE here, outside on_attach
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = organize_imports_group,
    pattern = { "*.ts", "*.tsx" },
    callback = function(args)
      -- Exclude spec files
      if args.file:match("%.spec%.ts$") then
        return
      end

      -- Check if typescript-tools client is attached to this buffer
      local clients = vim.lsp.get_clients({ bufnr = args.buf, name = "typescript-tools" })
      if #clients == 0 then
        return
      end

      -- Run organize imports synchronously, wrapped in pcall to handle LSP not ready
      local ok, _ = pcall(function()
        vim.cmd("TSToolsOrganizeImports sync")
      end)
      if not ok then
        -- Silently ignore errors (LSP might not be ready yet)
      end
    end,
  })

  require("typescript-tools").setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      vim.keymap.set("n", "gd", "<cmd>TSToolsGoToSourceDefinition<cr>", { buffer = bufnr })
      vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { buffer = bufnr })
      vim.keymap.set("n", "K", "<cmd>TSToolsHover<cr>", { buffer = bufnr })
      vim.keymap.set("n", "<leader>ca", "<cmd>TSToolsFixAll<cr>", { buffer = bufnr })
      vim.keymap.set("n", "<leader>frn", "<cmd>TSToolsRename<cr>", { buffer = bufnr })
      vim.keymap.set("n", "<leader>o", "<cmd>TSToolsOrganizeImports<cr>", { buffer = bufnr })
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
