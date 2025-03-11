-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
		'mfussenegger/nvim-jdtls',
		requires = { 'nvim-lua/plenary.nvim', 'williamboman/mason.nvim' }
	}

	use {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'neovim/nvim-lspconfig',
		'mfussenegger/nvim-dap',
		'jay-babu/mason-nvim-dap.nvim',
		run = ':MasonUpdate', -- Updates registry on install
	}

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	use ({
		'rose-pine/neovim',
		as = 'rose-pine',
		config = function()
			vim.cmd('colorscheme rose-pine')
		end
	})

	use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
	use('theprimeagen/harpoon')

	use {
		'hrsh7th/nvim-cmp',
		requires = {
			'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
			'hrsh7th/cmp-buffer',   -- Optional: completions from buffer
			'hrsh7th/cmp-path',     -- Optional: filesystem paths
			'L3MON4D3/LuaSnip',     -- Optional: snippet engine
			'saadparwaiz1/cmp_luasnip' -- Optional: LuaSnip integration
		}
	}

	use('github/copilot.vim')

end)
