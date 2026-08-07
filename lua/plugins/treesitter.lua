-- plugins/treesitter.lua — Treesitter parsers (lazy spec)
-- nvim-treesitter was fully rewritten (2026): highlighting/indent are
-- native Neovim now; this plugin only manages parser installs/updates.
-- Per the official README:
--   • it does NOT support lazy-loading (lazy = false)
--   • parser install/update is automated via build (lazy runs it on
--     install/update; TSUpdate alone only UPDATES installed parsers)
--   • setup() is optional (defaults are fine)
-- The parser list lives in config/treesitter-langs.lua (shared with the
-- LazyDone hook in config/lazy.lua).

return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = function()
    require('nvim-treesitter').install(require('config.treesitter-langs'))
  end,
  config = function()
    require('nvim-treesitter').setup()
    -- Treesitter owns its parser maintenance: after every lazy update
    -- (User LazyDone) ensure the curated parser set. Install is
    -- idempotent (present parsers skip fast), so this just fills gaps.
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyDone',
      callback = function()
        vim.schedule(function()
          local ok, nt = pcall(require, 'nvim-treesitter')
          if ok and nt and nt.install then
            pcall(nt.install, require('config.treesitter-langs'))
          end
        end)
      end,
    })
  end,
}
