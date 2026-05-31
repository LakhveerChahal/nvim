return {
  cmd = { 'pylsp' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
  filetypes = { 'python' },
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = { 'E501' },
        },
        mypy = {
          enabled = true,
          live_mode = true,
        },
      },
    },
  },
}
