-- 1. Set up dap-ui globally
local dapui = require("dapui")
dapui.setup()
-- 2. Auto-open/close UI on debug events
local dap = require("dap")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
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
vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "Debug: Restart" })
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: Step Into" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Debug: Step Over" })
vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Debug: Step Out" })
vim.keymap.set("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug: Conditional Breakpoint" })

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
