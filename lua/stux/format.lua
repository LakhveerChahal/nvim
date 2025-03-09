local function smart_format()
	local mode = vim.api.nvim_get_mode().mode -- Get current mode
	local pos = vim.api.nvim_win_get_cursor(0) -- Save cursor position
	local clients = vim.lsp.get_active_clients({ bufnr = 0 })
	local filetype = vim.bo.filetype
	local has_formatter = false

	-- Preferred LSPs for each filetype
	local preferred_clients = {
		java = "jdtls",
		typescript = "tsserver",
		javascript = "tsserver",
		sh = "bashls",
		-- Add more as needed
	}

	-- Helper to get visual selection range
	local function get_visual_range()
		local start_pos = vim.api.nvim_buf_get_mark(0, '<')
		local end_pos = vim.api.nvim_buf_get_mark(0, '>')
		return {
			start = { start_pos[1], start_pos[2] },
			['end'] = { end_pos[1], end_pos[2] }
		}
	end

	-- Step 1: Try the preferred client
	local preferred = preferred_clients[filetype]
	if preferred then
		for _, client in ipairs(clients) do
			if client.name == preferred then
				if mode == 'v' or mode == 'V' then
					-- Visual mode: Format selected range
					local range = get_visual_range()
					vim.lsp.buf.format({
						async = false,
						filter = function(c) return c.name == preferred end,
						range = { start = range.start, ['end'] = range['end'] }
					})
					print('Formatted range with preferred LSP: ' .. client.name)
				else
					-- Normal mode: Format whole file
					vim.lsp.buf.format({ async = false, filter = function(c) return c.name == preferred end })
					print('Formatted file with preferred LSP: ' .. client.name)
				end
				has_formatter = true
				break
			end
		end
	end

	-- Step 2: Fallback to any LSP with formatting
	if not has_formatter then
		for _, client in ipairs(clients) do
			if client.server_capabilities.documentFormattingProvider then
				if mode == 'v' or mode == 'V' then
					local range = get_visual_range()
					vim.lsp.buf.format({
						async = false,
						range = { start = range.start, ['end'] = range['end'] }
					})
					print('Formatted range with fallback LSP: ' .. client.name)
				else
					vim.lsp.buf.format({ async = false })
					print('Formatted file with fallback LSP: ' .. client.name)
				end
				has_formatter = true
				break
			end
		end
	end

	-- Step 3: Fallback to Neovim indenting
	if not has_formatter then
		if mode == 'v' or mode == 'V' then
			vim.cmd('normal! =') -- Indent selected range
			print('Indented range with Neovim')
		else
			vim.cmd('normal! gg=G') -- Indent whole file
			print('Indented file with Neovim')
		end
	end

	-- Restore cursor position (adjusted for visual mode)
	if mode ~= 'v' and mode ~= 'V' then
		vim.api.nvim_win_set_cursor(0, pos)
	end
end

-- Bind to <leader>= for both normal and visual modes
vim.keymap.set({'n', 'v'}, '<leader>=', smart_format, { desc = 'Smart format file or range' })
