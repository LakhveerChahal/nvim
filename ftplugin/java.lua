-- Import LSP keybindings
local key_bindings = require('stux.java-bindings')

local util = require('lspconfig.util')

local function find_topmost_pom(filepath)
	local util = require('lspconfig.util')
	
	-- Find the project root by locating the .git directory
	local project_root = util.find_git_ancestor(filepath)
	if not project_root then
	  return 'default' -- No .git found, meaning no project root
	end
	
	-- Start from the directory of the given file
	local current_dir = util.path.dirname(filepath)
	local topmost_pom = nil
	
	-- Traverse up the directory tree until reaching the project root
	while current_dir and current_dir ~= project_root do
	  local pom_path = current_dir .. '/pom.xml'
	  if vim.fn.filereadable(pom_path) == 1 then
		topmost_pom = pom_path
		-- Don't break here; keep going up to find the topmost one
	  end
	  current_dir = util.path.dirname(current_dir)
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
		'-javaagent:' .. vim.fn.expand('~') .. '/.config/nvim/nvim-plugins/lombok.jar',
		'-jar', vim.fn.glob(vim.fn.expand('~') .. '/.config/nvim/nvim-plugins/nvim-jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
		'-configuration', vim.fn.expand('~') .. '/.config/nvim/nvim-plugins/nvim-jdtls/config_linux', -- Adjust for your OS
		'-data', os.getenv('HOME') .. '/nvim-space/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ":h:t") .. '/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
	},
	root_dir = util.path.dirname(find_topmost_pom(vim.fn.expand('%:p'))),
	capabilities = require('cmp_nvim_lsp').default_capabilities(),
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
	init_options = {
		bundles = {
			vim.fn.glob(vim.fn.expand('~') .. '/.config/nvim/nvim-plugins/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar', 1),
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
