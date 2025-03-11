local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  -- Enable snippet support
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- Use LuaSnip for snippet expansion
    end,
  },
  -- Key mappings
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- Scroll docs up
    ['<C-f>'] = cmp.mapping.scroll_docs(4),  -- Scroll docs down
    ['<C-Space>'] = cmp.mapping.complete(),  -- Trigger completion manually
    ['<C-e>'] = cmp.mapping.abort(),         -- Cancel completion
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept selection with Enter
    -- Navigate between snippet placeholders
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  -- Sources for completion
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- LSP completions (JDTLS)
    { name = 'luasnip' },  -- Snippets
    { name = 'buffer' },   -- Buffer words
    { name = 'path' },     -- File paths
  }),
  -- Optional: Formatting of completion items
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
        luasnip = '[Snippet]',
        buffer = '[Buffer]',
        path = '[Path]',
      })[entry.source.name]
      return vim_item
    end,
  },
})

-- for auto popups
cmp.event:on('InsertEnter', cmp.mapping.complete())