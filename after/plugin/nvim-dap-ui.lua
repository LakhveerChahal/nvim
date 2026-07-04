-- 1. Set up dap-ui globally
local dapui = require("dapui")
dapui.setup({
    layouts = {
        {
            elements = {
                { id = "scopes", size = 1 },
            },
            position = "bottom",
            size = 20,
        }
    }
})
-- 2. Auto-open/close UI on debug events
local dap = require("dap")
dap.adapters.python = {
    options = {
        initialize_timeout_sec = 15,  -- Increase timeout for slow environments
    },
}
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
-- 3. Set up Python adapter with venv detection
require("dap-python").setup("python")  -- uses current venv's python
-- 4. Global DAP keybindings
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: Continue" })
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set('n', '<leader>dr', function () dap.repl.toggle({height = 15}) end, { desc = "Debug: Toggle REPL" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: Step Into" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Debug: Step Over" })
vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Debug: Step Out" })
vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "Debug: Run to Cursor" })
vim.keymap.set("n", "<leader>dR", dap.restart_frame, { desc = "Debug: Restart Frame" })

vim.keymap.set("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug: Conditional Breakpoint" })

-- DAP UI toggle keybinding
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })
-- Sign define
vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "", linehl = "", numhl = "" })


-- Float specific DAP-UI panels
vim.keymap.set("n", "<leader>dt", function()
  dapui.float_element("console", { enter = true })
end, { desc = "Debug: Float Console/Terminal" })
vim.keymap.set("n", "<leader>ds", function()
  dapui.float_element("scopes", { enter = true })
end, { desc = "Debug: Float Scopes" })
vim.keymap.set("n", "<leader>dw", function()
  dapui.float_element("watches", { enter = true })
end, { desc = "Debug: Float Watches" })
vim.keymap.set("n", "<leader>dk", function()
  dapui.float_element("stacks", { enter = true })
end, { desc = "Debug: Float Call Stack" })
