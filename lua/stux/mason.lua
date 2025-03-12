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
		'-javaagent:' .. vim.fn.stdpath('data') .. '/mason/packages/jdtls/lombok.jar',
		'-jar', vim.fn.glob(vim.fn.stdpath('data') .. '/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
		'-configuration', vim.fn.stdpath('data') .. '/mason/packages/jdtls/config_linux', -- Adjust for your OS
		'-data', os.getenv('HOME') .. '/nvim-space/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ":h:t") .. '/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
	},
	root_dir = vim.fs.root(0, {"mvnw", "pom.xml"}), -- Adjust as needed
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
			format = {
				enabled = true, -- Ensure formatting is enabled
				insertSpaces = true,
				tabSize = 4,
				settings = {
					url = vim.fn.stdpath('config') .. '/lua/stux/java_formatter.xml',-- Optional: Path to a custom Eclipse formatter XML (leave nil for defaults)
					profile = "Custom", -- Optional: Formatter profile name (if using XML)
				},
			},
			saveActions = {
				organizeImports = true,
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
		}
	},
	init_options = {
		bundles = {
			vim.fn.glob(vim.fn.expand('~') .. '/nvim-plugins/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar', 1),
		},
	},
	on_attach = function(client, bufnr)
		-- Set indentation settings for Java buffers
		vim.bo[bufnr].expandtab = true
		vim.bo[bufnr].shiftwidth = 4
		vim.bo[bufnr].tabstop = 4
	end,
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
