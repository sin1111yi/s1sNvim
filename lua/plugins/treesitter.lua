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
    -- Highlighting is native (vim.treesitter.start); buffers opened by a
    -- wokamark session restore may have missed the trigger while this
    -- plugin was still loading — apply it to every loaded file buffer.
    vim.schedule(function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf)
          and vim.bo[buf].filetype ~= ''
          and vim.bo[buf].buftype == '' then
          pcall(vim.treesitter.start, buf)
        end
      end
    end)
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
