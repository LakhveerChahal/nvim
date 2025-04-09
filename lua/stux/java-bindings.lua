local M = {}

function M.setup_jdtls_keymappings(bufnr)

  require("dapui").setup()
  vim.keymap.set('n', '<leader>du', '<cmd>lua require("dapui").toggle()<CR>', { desc = "Toggle DAP UI" })

  -- Function to trigger an incremental build
  function JdtIncrementalBuild()
    require('jdtls').compile('full') -- full or incremental
  end

  -- Create a user command
  vim.api.nvim_create_user_command('JavaBuild', JdtIncrementalBuild, {})

  -- DAP keybindings
  vim.keymap.set('n', '<leader>rm', '<cmd>lua require("jdtls").compile("full") <CR>', opts, { desc = "Compile project" })
  vim.keymap.set('n', '<leader>dc', '<cmd>lua require("dap").continue() <CR>', opts, { desc = "Run main class" })
  vim.keymap.set('n', '<leader>dr', '<cmd>lua require("dap").restart() <CR>', opts, { desc = "Run main class" })
  vim.keymap.set('n', '<leader>db', '<cmd>lua require("dap").toggle_breakpoint()<CR>', opts, { desc = "Toggle breakpoint" })

end

return M
