-- plugins/treesitter.lua — Treesitter syntax highlighting (lazy spec)
-- Loaded on first BufReadPost/BufNewFile (equivalent to old once).
-- build runs :TSUpdate on first install so parsers are fetched.

return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost', 'BufNewFile' },
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup({
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = { enable = true },
    })
  end,
}
