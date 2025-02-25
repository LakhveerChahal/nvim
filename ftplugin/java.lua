--- Avoid loading JDTLS multiple times for the same buffer
if vim.b.jdtls_loaded then
  return
end
vim.b.jdtls_loaded = true

local jdtls = require('jdtls')
local home = os.getenv('HOME')
local mason_path = vim.fn.stdpath('data') .. '/mason'

-- JDTLS paths
local jdtls_path = mason_path .. '/packages/jdtls'
local launcher = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
local config_dir = jdtls_path .. '/config_linux' -- Adjust: config_mac, config_win


-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.

local project_pwd = vim.fn.getcwd()
local nvim_workspace_dir = vim.fn.expand('~') .. 'nvim-space/' .. project_pwd

local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    -- 💀
    'java', -- or '/path/to/java21_or_newer/bin/java'
            -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-configuration', config_dir,

    -- 💀
    -- See `data directory configuration` section in the README
    '-data', nvim_workspace_dir 
  },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  --
  -- vim.fs.root requires Neovim 0.10.
  -- If you're using an earlier version, use: require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
  root_dir = vim.fs.root(0, {".git", "mvnw"}),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
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
	vim.fn.glob(vim.fn.expand('~') .. 'nvim-space/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar', 1)
    }
  },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
