-- plugins/cmp.lua — Autocompletion (lazy spec list: nvim-cmp + LuaSnip +
-- cmp-buffer + cmp-path + cmp-nvim-lsp)
-- nvim-cmp loads on first InsertEnter; LuaSnip/cmp-buffer/cmp-path load as
-- its deps. which-key is a dep too: cmp's config requires
-- plugin-keymaps.cmp_map, and plugin-keymaps runs inside which-key's
-- config, so which-key must be loaded first (race eliminated, ADR D-003).

return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'folke/which-key.nvim',
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            pcall(function() require('luasnip').lsp_expand(args.body) end)
          end,
        },
        mapping = require('plugins.custom.cmp').build(require('plugins.custom.plugin-keymaps').cmp_map, cmp),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
      })
    end,
  },
  -- cmp-nvim-lsp: declared here (no own trigger), pulled in by lspconfig deps
}
