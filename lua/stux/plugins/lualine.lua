return {
    {
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
	},

	{
		"linrongbin16/lsp-progress.nvim",
		config = function()
		  require("lsp-progress").setup()
		end,
	}
}