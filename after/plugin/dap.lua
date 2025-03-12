local dap = require('dap')

dap.configurations.java = {
  {
    type = 'java-debug-adapter', -- Match mason-nvim-dap’s type
    request = 'launch',
    name = "Launch Current File",
    mainClass = function()
      return vim.fn.expand('%:r'):gsub('/', '.') 
    end,
    projectName = vim.fn.fnamemodify(vim.fn.getcwd(), ':t'),
  },
}