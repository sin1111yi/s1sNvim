-- plugins/treesitter.lua — Treesitter parsers (lazy spec)
-- nvim-treesitter was fully rewritten (2026): highlighting/indent are
-- native Neovim now; this plugin only manages parser installs/updates.
-- Per the official README:
--   • it does NOT support lazy-loading (lazy = false)
--   • parser install/update is automated via build (lazy runs it on
--     install/update; TSUpdate alone only UPDATES installed parsers)
--   • setup() is optional (defaults are fine)

return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = function()
    -- Install a curated parser set. Install is idempotent (already
    -- installed parsers are skipped quickly), so build can safely run on
    -- every lazy install/update.
    local langs = {
      'lua', 'vim', 'vimdoc', -- this config itself
      'rust', 'c', 'cpp', 'python', 'go', -- dev languages
      'bash', 'json', 'toml', 'yaml', 'markdown', -- config/data
      'html', 'css', 'javascript', 'typescript', -- web
      'make', 'cmake', -- build tooling
    }
    require('nvim-treesitter').install(langs)
  end,
  config = function()
    require('nvim-treesitter').setup()
  end,
}
