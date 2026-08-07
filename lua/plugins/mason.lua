-- plugins/mason.lua — LSP server installer (lazy spec list)
-- mason + mason-lspconfig have no own triggers: they load as deps of
-- nvim-lspconfig (declared in lsp.lua). ensure_installed servers are
-- installed when the LSP chain first loads.

return {
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = { 'rust_analyzer', 'lua_ls', 'clangd', 'taplo' },
        automatic_installation = true,
      })
    end,
  },
}
