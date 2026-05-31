-- Skip loading JDTLS if it is already running
if vim.b.jdtls_active then
	return
end

-- Import LSP keybindings
local key_bindings = require('stux.java-bindings')

local function find_topmost_pom(filepath)
	local project_root = vim.fs.root(filepath, '.git')
	if not project_root then
	  return 'default'
	end

	local current_dir = vim.fn.fnamemodify(filepath, ':h')
	local topmost_pom = nil

	while current_dir and current_dir ~= project_root do
	  local pom_path = current_dir .. '/pom.xml'
	  if vim.fn.filereadable(pom_path) == 1 then
		topmost_pom = pom_path
	  end
	  current_dir = vim.fn.fnamemodify(current_dir, ':h')
	end

	return topmost_pom
end

-- JDTLS Configuration
local jdtls_config = {
	cmd = {
		'java', -- Ensure this points to Java 17+ (or use full path: '/usr/lib/jvm/java-17-openjdk/bin/java')
		'-Declipse.application=org.eclipse.jdt.ls.core.id1',
		'-Dosgi.bundles.defaultStartLevel=4',
		'-Declipse.product=org.eclipse.jdt.ls.core.product',
		'-Dlog.protocol=true',
		'-Dlog.level=ALL',
		'-Xss8m',
		'-Xmx8g',
		'--add-modules=ALL-SYSTEM',
		'--add-opens', 'java.base/java.util=ALL-UNNAMED',
		'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
		'-javaagent:' .. vim.fn.expand('~') .. '/nvim-plugins/lombok.jar',
		'-jar', vim.fn.glob(vim.fn.expand('~') .. '/nvim-plugins/nvim-jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
		'-configuration', vim.fn.expand('~') .. '/nvim-plugins/nvim-jdtls/config_linux', -- Adjust for your OS
		'-data', os.getenv('HOME') .. '/nvim-space/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ":h:t") .. '/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
	},
	root_dir = vim.fn.getcwd(),
	capabilities = vim.lsp.protocol.make_client_capabilities(),
	settings = {
		-- Here you can configure eclipse.jdt.ls specific settings
		-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
		-- for a list of options
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
					url = vim.fn.stdpath('config') .. '/after/plugin/java_formatter.xml',-- Optional: Path to a custom Eclipse formatter XML (leave nil for defaults)
					profile = "Custom", -- Optional: Formatter profile name (if using XML)
				},
			},
			saveActions = {
				organizeImports = true,
			},
			configuration = {
				updateBuildConfiguration = "automatic",
				maven = {
					globalSettings = vim.fn.expand('~') .. "/.m2/settings.xml"
				}
			},
			eclipse = {
				downloadSources = true,
			},
			maven = {
				downloadSources = true,
				updateSnapshots = true
			},
			jdt = {
				ls = {
					lombokSupport = {
						enabled = true,
					}
				}
			},
		}
	},
	-- Language server `initializationOptions`
	-- You need to extend the `bundles` with paths to jar files
	-- if you want to use additional eclipse.jdt.ls plugins.
	--
	-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
	--
	-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
	init_options = {
		bundles = {
			vim.fn.glob(vim.fn.expand('~') .. '/nvim-plugins/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar', 1),
		},
		extendedClientCapabilities = {
			progressReportProvider = true,
		},
	},
	on_attach = function(client, bufnr)
		-- keybindings
		key_bindings.setup_jdtls_keymappings(bufnr)

		-- Setup DAP with JDTLS
		require('jdtls').setup_dap({ hotcodereplace = 'auto' })
		-- Auto-discover main classes
		require('jdtls.dap').setup_dap_main_class_configs()
	end,
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(jdtls_config)
