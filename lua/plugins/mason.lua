-- plugins/mason.lua — LSP server installer (lazy spec list)
-- mason + mason-lspconfig have no own triggers: they load as deps of
-- nvim-lspconfig (declared in lsp.lua). ensure_installed servers are
-- installed when the LSP chain first loads.

return {
  {
    'williamboman/mason.nvim',
    commit = '2a6940af80375532e5e9e7c1f2fc6319a1b7a69d', -- migration pin
    config = function()
      require('mason').setup()
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    commit = '47059d71b42d74b0a1e9f61c1d99d301039c3b5b', -- migration pin
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = { 'rust_analyzer', 'lua_ls', 'clangd', 'taplo' },
        automatic_installation = true,
      })
    end,
  },
}
