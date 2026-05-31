return {
  cmd = { 'vscode-css-language-server', '--stdio' },
  root_markers = { 'package.json', '.git' },
  filetypes = { 'css', 'scss', 'less' },
  settings = {
    css = {
      validate = true,
      lint = { unknownAtRules = 'ignore' },
      hover = { documentation = true, references = true },
      completion = {
        triggerPropertyValueCompletion = true,
        completePropertyWithSemicolon = true,
      },
    },
    scss = {
      validate = true,
      lint = { unknownAtRules = 'ignore' },
    },
    less = {
      validate = true,
      lint = { unknownAtRules = 'ignore' },
    },
  },
}
