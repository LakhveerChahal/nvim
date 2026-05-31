return {
  cmd = { 'typescript-language-server', '--stdio' },
  root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
  filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx', 'javascript', 'javascriptreact', 'javascript.jsx' },
  on_attach = function(client, bufnr)
    vim.keymap.set('n', '<leader>oi', function()
      vim.lsp.buf.code_action({
        apply = true,
        context = { only = { 'source.organizeImports' }, diagnostics = {} },
      })
    end, { buffer = bufnr, desc = 'Organize imports' })
  end,
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
  },
}
