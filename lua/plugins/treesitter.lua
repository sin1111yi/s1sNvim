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
    -- Highlighting is native (vim.treesitter.start); the buffer that
    -- TRIGGERED this lazy load missed the BufReadPost auto-start (its
    -- event already fired while treesitter was still loading). Re-apply
    -- to every loaded file buffer.
    vim.schedule(function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf)
          and vim.bo[buf].filetype ~= ''
          and vim.bo[buf].buftype == '' then
          pcall(vim.treesitter.start, buf)
        end
      end
    end)
  end,
}
