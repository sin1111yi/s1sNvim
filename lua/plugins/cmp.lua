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
    commit = '2ffe79f1f021def8dd1fcd81deb16f1bb0d989f3', -- migration pin
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
  { 'L3MON4D3/LuaSnip', commit = '0abc8f390b278c3b4aabc4c004ac8a088b65cf24' }, -- migration pin
  { 'hrsh7th/cmp-buffer', commit = 'b74fab3656eea9de20a9b8116afa3cfc4ec09657' }, -- migration pin
  { 'hrsh7th/cmp-path', commit = 'c642487086dbd9a93160e1679a1327be111cbc25' }, -- migration pin
  -- cmp-nvim-lsp: declared here (no own trigger), pulled in by lspconfig deps
  { 'hrsh7th/cmp-nvim-lsp', commit = 'cbc7b02bb99fae35cb42f514762b89b5126651ef' }, -- migration pin
}
