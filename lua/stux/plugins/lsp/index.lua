return {
    {
      "neovim/nvim-lspconfig",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "pmizio/typescript-tools.nvim",
        "nvim-lua/plenary.nvim",
        "L3MON4D3/LuaSnip"
      },
      config = function()
        local common = require("stux.plugins.lsp.configs.common")
        local capabilities = common.setup()

        require("stux.plugins.lsp.configs.typescript").setup(capabilities)
        require("stux.plugins.lsp.configs.angular").setup()
        require("stux.plugins.lsp.configs.go")
        require("stux.plugins.lsp.configs.python").setup(capabilities)
      end
    }
  }
  
