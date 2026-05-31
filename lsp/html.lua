return {
  cmd = { 'vscode-html-language-server', '--stdio' },
  root_markers = { 'package.json', '.git' },
  filetypes = { 'html' },
  init_options = {
    configurationSection = { 'html', 'css', 'javascript' },
    embeddedLanguages = {
      css = true,
      javascript = true,
    },
  },
  settings = {
    html = {
      format = {
        indentInnerHtml = true,
        wrapLineLength = 120,
        wrapAttributes = 'auto',
        templating = true,
      },
      hover = {
        documentation = true,
        references = true,
      },
      completion = {
        attributeDefaultValue = 'doublequotes',
      },
      validate = {
        scripts = true,
        styles = true,
      },
    },
  },
}
