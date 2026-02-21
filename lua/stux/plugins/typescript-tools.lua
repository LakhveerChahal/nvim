return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  config = function()
    require("typescript-tools").setup {
      on_attach = function(client, bufnr)
        -- Added this because on_attach is not invoking when opening a ts file, seems like a bug in plugin.
        print("attaching key bindings for bufnr:", bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gd", "<cmd>TSToolsGoToSourceDefinition<cr>", bufopts)
        vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", bufopts)
        vim.keymap.set("n", "K", "<cmd>TSToolsHover<cr>", bufopts)
        vim.keymap.set("n", "<leader>ca", "<cmd>TSToolsFixAll<cr>", bufopts)
        vim.keymap.set("n", "<leader>frn", "<cmd>TSToolsRename<cr>", bufopts)
        vim.keymap.set("n", "<leader>o", "<cmd>TSToolsOrganizeImports<cr>", bufopts)

        -- BufWritePre with group/buffer
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("TSTools", { clear = true }),
          buffer = bufnr,
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
      },
    }
  end,
}

