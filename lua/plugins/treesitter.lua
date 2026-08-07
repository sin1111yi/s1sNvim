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
    -- Highlighting is native (vim.treesitter.start). Buffers opened by a
    -- wokamark session restore may miss the trigger while this plugin was
    -- loading AND may not have their filetype set yet when the lazy-load
    -- config runs — the FileType event fires once detection completes, so
    -- start TS from there (idempotent for already-highlighted buffers).
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        vim.schedule(function()
          local buf = args.buf
          if vim.api.nvim_buf_is_valid(buf)
            and vim.bo[buf].buftype == ''
            and vim.bo[buf].filetype ~= '' then
            pcall(vim.treesitter.start, buf)
          end
        end)
      end,
    })
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
