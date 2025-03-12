local telescope = require('telescope')

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
        ["<C-q>"] = "send_to_qflist",
      },
    },
  },
  pickers = {
    live_grep = {
      additional_args = function()
        return { "--hidden", "--no-ignore" } -- Search hidden files, ignore .gitignore
      end,
    },
  },
})

-- Load Telescope
local builtin = require('telescope.builtin')

-- Keybindings (global, not buffer-specific)
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live grep in project" })
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find buffers" })
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
