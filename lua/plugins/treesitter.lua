-- plugins/treesitter.lua — Treesitter parsers (lazy spec)
-- nvim-treesitter was rewritten (2026): highlighting/indent are native
-- Neovim; this plugin manages parser installs/updates.
-- Loaded on any buffer-open event; parsers listed in
-- config/treesitter-langs.lua are installed via build / LazyDone hook.

return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufEnter', 'BufReadPost', 'BufNewFile', 'BufNew' },
  build = function()
    require('nvim-treesitter').install(require('config.treesitter-langs'))
  end,
  config = function()
    require('nvim-treesitter').setup()
    -- Ensure the parser set after every lazy update (idempotent).
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
