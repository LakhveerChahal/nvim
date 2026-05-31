-- Angular Language Server configuration
-- Uses custom root_dir and cmd logic for monorepo/project detection

local function find_project_root(filepath)
  local current_file = filepath or vim.api.nvim_buf_get_name(0)
  local current_dir = vim.fn.fnamemodify(current_file, ':h')

  if current_file == '' or current_dir == '' then
    return vim.fn.getcwd()
  end

  local markers = { 'angular.json', 'package.json' }
  local dir = current_dir

  while dir ~= '/' and dir ~= '' do
    for _, marker in ipairs(markers) do
      local marker_path = dir .. '/' .. marker
      if vim.fn.filereadable(marker_path) == 1 then
        if marker == 'package.json' then
          local content = vim.fn.readfile(marker_path)
          local json_str = table.concat(content, '\n')
          if json_str:find('@angular/core') then
            return dir
          end
        else
          return dir
        end
      end
    end
    dir = vim.fn.fnamemodify(dir, ':h')
  end

  return vim.fn.getcwd()
end

local function build_cmd(project_root)
  local node_modules = project_root .. '/node_modules'
  local local_ng_service = node_modules .. '/@angular/language-service'
  local use_local_ng = vim.fn.isdirectory(local_ng_service) == 1

  local cmd = {
    'ngserver',
    '--stdio',
    '--tsProbeLocations', project_root,
    '--ngProbeLocations', project_root,
  }

  if use_local_ng then
    table.insert(cmd, '--tsProbeLocations')
    table.insert(cmd, node_modules)
    table.insert(cmd, '--ngProbeLocations')
    table.insert(cmd, node_modules)
  end

  return cmd
end

return {
  cmd = function(dispatchers, config)
    local project_root = config.root_dir or find_project_root()
    local cmd = build_cmd(project_root)
    return vim.lsp.rpc.start(cmd, dispatchers, {
      cwd = project_root,
    })
  end,
  root_dir = function(bufnr, on_dir)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local root = find_project_root(bufname)
    on_dir(root)
  end,
  filetypes = { 'typescript', 'html', 'htmlangular', 'typescriptreact', 'typescript.tsx', 'css', 'less' },
  settings = {
    angular = {
      enable = true,
      trace = { server = 'messages' },
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
    },
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.referencesProvider = false

    local function get_base(filename)
      return filename:gsub('%.component%.spec%.ts$', '.component')
        :gsub('%.component%.ts$', '.component')
        :gsub('%.component%.html$', '.component')
        :gsub('%.component%.css$', '.component')
        :gsub('%.component%.less$', '.component')
    end

    local opts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set('n', '<leader>at', function()
      local base = get_base(vim.api.nvim_buf_get_name(0))
      local ts = base .. '.ts'
      if vim.fn.filereadable(ts) == 1 then
        vim.cmd('edit ' .. vim.fn.fnameescape(ts))
      else
        vim.notify('.ts not found: ' .. ts, vim.log.levels.INFO)
      end
    end, opts)

    vim.keymap.set('n', '<leader>ah', function()
      local base = get_base(vim.api.nvim_buf_get_name(0))
      local html = base .. '.html'
      if vim.fn.filereadable(html) == 1 then
        vim.cmd('edit ' .. vim.fn.fnameescape(html))
      else
        vim.notify('.html not found: ' .. html, vim.log.levels.INFO)
      end
    end, opts)

    vim.keymap.set('n', '<leader>as', function()
      local base = get_base(vim.api.nvim_buf_get_name(0))
      local spec = base .. '.spec.ts'
      if vim.fn.filereadable(spec) == 1 then
        vim.cmd('edit ' .. vim.fn.fnameescape(spec))
      else
        vim.notify('.spec.ts not found: ' .. spec, vim.log.levels.INFO)
      end
    end, opts)

    vim.keymap.set('n', '<leader>ac', function()
      local base = get_base(vim.api.nvim_buf_get_name(0))
      local css = base .. '.css'
      if vim.fn.filereadable(css) == 1 then
        vim.cmd('edit ' .. vim.fn.fnameescape(css))
      else
        vim.notify('.css not found: ' .. css, vim.log.levels.INFO)
      end
    end, opts)

    vim.keymap.set('n', '<leader>al', function()
      local base = get_base(vim.api.nvim_buf_get_name(0))
      local less = base .. '.less'
      if vim.fn.filereadable(less) == 1 then
        vim.cmd('edit ' .. vim.fn.fnameescape(less))
      else
        vim.notify('.less not found: ' .. less, vim.log.levels.INFO)
      end
    end, opts)
  end,
}
