-- return {}
return {
  "nickjvandyke/opencode.nvim",
  version = "*", -- Latest stable release
  dependencies = {
    { -- Removed "formatted_rules =" here
      -- `snacks.nvim` integration is recommended, but optional
      ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
      "folke/snacks.nvim",
      optional = true,
      opts = {
        input = {}, -- Enhances `ask()`
        picker = { -- Enhances `select()`
          actions = {
            opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
  },
config = function()
    -- 1. Define your terminal command and options for snacks
    local opencode_cmd = 'opencode'
    local snacks_terminal_opts = {
      win = {
        position = 'right',
        enter = false,
      },
    }

    -- 2. Configure opencode to use this terminal for its server
    vim.g.opencode_opts = {
      server = {
        start = function()
          require('snacks.terminal').open(opencode_cmd, snacks_terminal_opts)
        end,
      },
      -- Your other configuration, if any
    }

    vim.o.autoread = true -- Required for `opts.events.reload`

    -- Recommended/example keymaps
    vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
    vim.keymap.set({ "n", "x" }, "<leader>ox", function() require("opencode").select() end, { desc = "Execute opencode action…" })

    vim.keymap.set("n", "<leader>oo", function()
      require('snacks.terminal').toggle(opencode_cmd, snacks_terminal_opts)
    end, { desc = 'Toggle OpenCode' })

    vim.keymap.set({ "n", "x" }, "<leader>or", function() return require("opencode").operator("@this ") end, { desc = "Add range to opencode", expr = true })
    vim.keymap.set("n",          "<leader>ol", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })

    vim.keymap.set("t", "<C-u>", function() require("opencode").command("session.half.page.up") end, { desc = "Scroll opencode up" })
    vim.keymap.set("t", "<C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll opencode down" })

    vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n><C-w>p", { desc = "Focus previous window" })
  end,
}
