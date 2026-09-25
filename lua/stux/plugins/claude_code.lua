return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = true,
  -- `cmd` lets lazy.nvim create command stubs that load the plugin on first use,
  -- so `:ClaudeCode` and friends work on a fresh start. Without it, a keys-only
  -- spec defers loading until a <leader>a* mapping is pressed and the commands
  -- would not exist yet.
  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeSelectModel",
    "ClaudeCodeAdd",
    "ClaudeCodeSend",
    "ClaudeCodeTreeAdd",
    "ClaudeCodeStatus",
    "ClaudeCodeStart",
    "ClaudeCodeStop",
    "ClaudeCodeOpen",
    "ClaudeCodeClose",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
    "ClaudeCodeCloseAllDiffs",
  },
  keys = {
    { "<leader>o", nil, desc = "AI/Claude Code" },
    { "<leader>oo", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>of", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>or", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>oC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>om", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ob", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>os", "<cmd>ClaudeCodeSend<cr>", mode="v", desc = "Send to Claude" },
    { "<C-h>", [[<C-\><C-n><C-w>h]], mode = "t", desc = "Go to left window" },

    {
      "<leader>ot",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
    },
    { "<leader>oa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>od", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
}
