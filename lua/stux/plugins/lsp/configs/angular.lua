local M = {}

-- Find the Angular project root by searching for angular.json or package.json
-- starting from a given file path and walking up
-- @param filepath string|nil - the file path to start from, or nil to use current buffer
-- @return string - the project root directory
local function find_project_root(filepath)
    local current_file = filepath or vim.api.nvim_buf_get_name(0)
    local current_dir = vim.fn.fnamemodify(current_file, ':h')

    -- If no file is open, fall back to cwd
    if current_file == '' or current_dir == '' then
        return vim.fn.getcwd()
    end

    -- Walk up the directory tree looking for angular.json first (preferred), then package.json
    local markers = { 'angular.json', 'package.json' }
    local dir = current_dir

    while dir ~= '/' and dir ~= '' do
        for _, marker in ipairs(markers) do
            local marker_path = dir .. '/' .. marker
            if vim.fn.filereadable(marker_path) == 1 then
                -- For package.json, verify it's an Angular project by checking for @angular/core
                if marker == 'package.json' then
                    local content = vim.fn.readfile(marker_path)
                    local json_str = table.concat(content, '\n')
                    if json_str:find('@angular/core') then
                        return dir
                    end
                else
                    -- angular.json found - this is definitely an Angular project
                    return dir
                end
            end
        end
        -- Move to parent directory
        dir = vim.fn.fnamemodify(dir, ':h')
    end

    -- Fallback to cwd if no project root found
    return vim.fn.getcwd()
end

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
    local capabilities = require('stux.plugins.lsp.configs.common').setup()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    -- Build command with proper probe locations for a given project root
    local function build_cmd(project_root)
        local node_modules = project_root .. '/node_modules'

        -- Check if the project has its own @angular/language-service
        local local_ng_service = node_modules .. '/@angular/language-service'
        local use_local_ng = vim.fn.isdirectory(local_ng_service) == 1

        local cmd = {
            "ngserver",
            "--stdio",
            "--tsProbeLocations", project_root,
            "--ngProbeLocations", project_root,
        }

        -- If local Angular language service exists, tell ngserver to use it
        if use_local_ng then
            -- Add node_modules to the probe locations so ngserver uses the project's versions
            table.insert(cmd, "--tsProbeLocations")
            table.insert(cmd, node_modules)
            table.insert(cmd, "--ngProbeLocations")
            table.insert(cmd, node_modules)
        end

        return cmd
    end

    vim.lsp.config('angularls', {
        capabilities = capabilities,
        -- cmd as function: receives (dispatchers, config) and returns an RPC client
        -- config.root_dir will be set by the time this is called
        cmd = function(dispatchers, config)
            local project_root = config.root_dir or find_project_root()
            local cmd = build_cmd(project_root)
            -- Start the RPC connection: vim.lsp.rpc.start(cmd, dispatchers, extra_spawn_params)
            return vim.lsp.rpc.start(cmd, dispatchers, {
                cwd = project_root,
            })
        end,
        -- root_dir as function: receives (bufnr, on_dir_callback) for async support
        root_dir = function(bufnr, on_dir)
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local root = find_project_root(bufname)
            on_dir(root)
        end,
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
            client.server_capabilities.referencesProvider = false

            -- Keymaps specific to angularls
            local opts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set("n", "<leader>at", goto_component_ts, opts)
            vim.keymap.set("n", "<leader>ah", goto_component_html, opts)
            vim.keymap.set("n", "<leader>as", goto_component_spec, opts)
            vim.keymap.set("n", "<leader>ac", goto_component_css, opts)
            vim.keymap.set("n", "<leader>al", goto_component_less, opts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
        end,
    })

end

return M
