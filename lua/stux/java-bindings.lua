local M = {}

function M.setup_jdtls_keymappings(bufnr)

  -- Function to trigger an incremental build
  function JdtIncrementalBuild()
    require('jdtls').compile() -- full or incremental
  end

  -- Create a user command
  vim.api.nvim_create_user_command('JavaBuild', JdtIncrementalBuild, {})

  -- DAP keybindings
  vim.keymap.set('n', '<leader>rm', '<cmd>lua require("jdtls").compile("full") <CR>', opts, { desc = "Compile project" })

  -- Diagnostics
  vim.keymap.set('n', '<leader>sd', '<cmd>lua vim.diagnostic.setqflist()<CR>', opts, { desc = "Show diagnostics" })
  vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts, { desc = "Previous diagnostic" })
  vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts, { desc = "Next diagnostic" })

end

return M
