local M = {}

local function get_base(filename)
  -- removes .ts, .html, css, less or .spec.ts at the end to get the common prefix
  return filename:gsub('%.component%.spec%.ts$', '.component')
                :gsub('%.component%.ts$', '.component')
                :gsub('%.component%.html$', '.component')
                :gsub('%.component%.css$', '.component')
                :gsub('%.component%.less$', '.component')
end

function goto_component_ts()
  local filename = vim.api.nvim_buf_get_name(0)
  local base = get_base(filename)
  local ts = base .. '.ts'
  if vim.fn.filereadable(ts) == 1 then
    vim.cmd('edit ' .. vim.fn.fnameescape(ts))
  else
    vim.notify('.ts not found: ' .. ts, vim.log.levels.INFO)
  end
end

function goto_component_html()
  local filename = vim.api.nvim_buf_get_name(0)
  local base = get_base(filename)
  local html = base .. '.html'
  if vim.fn.filereadable(html) == 1 then
    vim.cmd('edit ' .. vim.fn.fnameescape(html))
  else
    vim.notify('.html not found: ' .. html, vim.log.levels.INFO)
  end
end

function goto_component_css()
  local filename = vim.api.nvim_buf_get_name(0)
  local base = get_base(filename)
  local css = base .. '.css'
  if vim.fn.filereadable(css) == 1 then
    vim.cmd('edit ' .. vim.fn.fnameescape(css))
  else
    vim.notify('.css not found: ' .. css, vim.log.levels.INFO)
  end
end

function goto_component_less()
  local filename = vim.api.nvim_buf_get_name(0)
  local base = get_base(filename)
  local css = base .. '.less'
  if vim.fn.filereadable(css) == 1 then
    vim.cmd('edit ' .. vim.fn.fnameescape(css))
  else
    vim.notify('.less not found: ' .. css, vim.log.levels.INFO)
  end
end

function goto_component_spec()
  local filename = vim.api.nvim_buf_get_name(0)
  local base = get_base(filename)
  local spec = base .. '.spec.ts'
  if vim.fn.filereadable(spec) == 1 then
    vim.cmd('edit ' .. vim.fn.fnameescape(spec))
  else
    vim.notify('.spec.ts not found: ' .. spec, vim.log.levels.INFO)
  end
end

function M.setup()
  local util = require('lspconfig.util')
  local capabilities = require('stux.plugins.lsp.configs.common').setup()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  require'lspconfig'.angularls.setup{
      capabilities = capabilities,
      settings = {
          angular = {
            enable = true,
            trace = {
              server = "messages"
            },
            diagnostics = {
              enable = true,
              templateErrors = true,
            },
            suggest = {
              fromTripleSlashReference = true,
              completeFunctionCalls = true,
            },
            format = {
              enable = true,
              insertSpaceAfterCommaDelimiter = true,
              insertSpaceAfterSemicolonInForStatements = true,
              insertSpaceBeforeAndAfterBinaryOperators = true,
              insertSpaceAfterKeywordsInControlFlowStatements = true,
              insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
              insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
              placeOpenBraceOnNewLineForFunctions = false,
              placeOpenBraceOnNewLineForControlBlocks = false,
            },
          }
      },
      filetypes = { "typescript", "html", "htmlangular", "typescriptreact", "typescript.tsx", "css", "less" },
      on_attach = function(client, bufnr)
          -- Keymaps specific to angularls
          local opts = { buffer = bufnr }
          vim.keymap.set("n", "<leader>at", goto_component_ts, opts)
          vim.keymap.set("n", "<leader>ah", goto_component_html, opts)
          vim.keymap.set("n", "<leader>as", goto_component_spec, opts)
          vim.keymap.set("n", "<leader>ac", goto_component_css, opts)
          vim.keymap.set("n", "<leader>al", goto_component_less, opts)
      end,
      root_dir = util.root_pattern("angular.json", "package.json"),
  }
end

return M
