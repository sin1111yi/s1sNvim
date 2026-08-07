-- plugins/treesitter.lua — Treesitter parsers (lazy spec)
-- Loaded on first BufReadPost/BufNewFile.
-- NOTE: nvim-treesitter was fully rewritten (2026) — the old
-- `nvim-treesitter.configs.setup` API is gone. Highlighting/indent are
-- now handled natively by Neovim; this plugin only manages parser
-- installs/updates via :TSUpdate.
-- build runs :TSUpdate on first install so parsers are fetched.

return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost', 'BufNewFile' },
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup()
  end,
}
