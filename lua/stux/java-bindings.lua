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
end

return M
