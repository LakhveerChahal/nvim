-- Create an augroup to manage Go-related autocommands
vim.api.nvim_create_augroup("goimports", { clear = true })

-- Set up an autocommand to organize imports and format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = "goimports",
  pattern = "*.go",
  callback = function()
    -- Organize imports using the "source.organizeImports" code action
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    -- Format the buffer after organizing imports
    vim.lsp.buf.format({ async = false })
  end,
})
