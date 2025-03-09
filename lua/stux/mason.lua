-- ~/.config/nvim/lua/stux/mason.lua
require('mason').setup()

-- JDTLS Configuration
local jdtls_config = {
	cmd = {
		'java', -- Ensure this points to Java 17+ (or use full path: '/usr/lib/jvm/java-17-openjdk/bin/java')
		'-Declipse.application=org.eclipse.jdt.ls.core.id1',
		'-Dosgi.bundles.defaultStartLevel=4',
		'-Declipse.product=org.eclipse.jdt.ls.core.product',
		'-Dlog.protocol=true',
		'-Dlog.level=ALL',
		'-Xmx1g',
		'--add-modules=ALL-SYSTEM',
		'--add-opens', 'java.base/java.util=ALL-UNNAMED',
		'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
		'-jar', vim.fn.glob(vim.fn.stdpath('data') .. '/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
		'-configuration', vim.fn.stdpath('data') .. '/mason/packages/jdtls/config_linux', -- Adjust for your OS
		'-log', os.getenv('HOME') .. '/.cache/jdtls-startup.log',
		'-data', os.getenv('HOME') .. '/nvim-space/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t'),
	},
	root_dir = vim.fs.root(0, {".git", "mvnw"}), -- Adjust as needed
	capabilities = require('cmp_nvim_lsp').default_capabilities(),
	settings = {
		java = {
			signatureHelp = { enabled = true },
			contentProvider = { preferred = 'fernflower' },
			completion = {
				favoriteStaticMembers = {
					'org.junit.Assert.*',
					'org.junit.Assume.*',
					'org.hamcrest.MatcherAssert.assertThat',
				},
			},
		},
		-- Add indentation settings
		format = {
			enabled = true, -- Ensure formatting is enabled
			settings = {
				url = nil, -- Optional: Path to a custom Eclipse formatter XML (leave nil for defaults)
				profile = nil, -- Optional: Formatter profile name (if using XML)
			},
		},
		configuration = {
			updateBuildConfiguration = "automatic",
		},
		eclipse = {
			downloadSources = true,
		},
		maven = {
			downloadSources = true,
		},
		-- Direct indentation settings (override defaults)
		["org.eclipse.jdt.core.formatter.tabulation.char"] = "space", -- Use spaces (or "tab" for tabs)
		["org.eclipse.jdt.core.formatter.tabulation.size"] = "4",    -- 4 spaces per indent level
	},
},
init_options = {
	bundles = {
		vim.fn.glob(vim.fn.expand('~') .. '/nvim-plugins/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar', 1),
	},
},
}

-- Mason-LSPConfig Setup
require("mason-lspconfig").setup({
	ensure_installed = { "jdtls", "angularls", "bashls" },
	automatic_installation = true,
	handlers = {
		-- Default handler for other LSPs
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,
		-- JDTLS-specific handler
		["jdtls"] = function()
			print("Loading JDTLS via mason-lspconfig...")
			require("lspconfig").jdtls.setup(jdtls_config)
		end,
	},
})

-- DAP Setup
require("mason-nvim-dap").setup({
	automatic_installation = true,
	handlers = {
		function(config)
			require("mason-nvim-dap").default_setup(config)
		end,
	},
})
