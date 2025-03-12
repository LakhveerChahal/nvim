local M = {}

function M.setup_jdtls_keymappings(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- Navigation
  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts, { desc = "Go to definition" })
  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts, { desc = "Go to declaration" })
  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts, { desc = "Go to implementation" })
  vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts, { desc = "Go to type definition" })
  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts, { desc = "Find references" })
  vim.keymap.set('n', '<leader>pd', '<cmd>lua vim.lsp.buf.peek_definition()<CR>', opts, { desc = "Peek definition" })

  -- Information
  vim.keymap.set('n', 'H', '<cmd>lua vim.lsp.buf.hover()<CR>', opts, { desc = "Show hover documentation" })
  vim.keymap.set('n', '<C-h>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts, { desc = "Show signature help" })

  -- Refactoring
  vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts, { desc = "Rename symbol" })
  vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts, { desc = "Code action" })

  -- Diagnostics
  vim.keymap.set('n', '<leader>sd', '<cmd>lua vim.diagnostic.setqflist()<CR>', opts, { desc = "Show diagnostics" })
  vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts, { desc = "Previous diagnostic" })
  vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts, { desc = "Next diagnostic" })
 
  -- DAP keybindings
  vim.keymap.set('n', '<leader>rm', '<cmd>lua require("dap").continue()<CR>', opts, { desc = "Run main class" })
  vim.keymap.set('n', '<leader>db', '<cmd>lua require("dap").toggle_breakpoint()<CR>', opts, { desc = "Toggle breakpoint" })
end

return M