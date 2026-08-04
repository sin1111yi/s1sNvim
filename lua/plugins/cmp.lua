-- plugins/cmp.lua — Autocompletion (nvim-cmp + LuaSnip)
-- Loaded on first InsertEnter (once)

local U = require('config.util')

-- Load luasnip module (no setup needed)
U.try_load('luasnip')

local ok, cmp = pcall(require, 'cmp')
if not ok then
  return false
end

cmp.setup({
  snippet = {
    expand = function(args)
      pcall(function() require('luasnip').lsp_expand(args.body) end)
    end,
  },
  mapping = require('plugins.custom.utils.cmp').build(require('plugins.custom.plugin-keymaps').cmp_map, cmp),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  }),
})

return true
