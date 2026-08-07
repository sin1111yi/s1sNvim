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
    -- Highlighting is native (vim.treesitter.start). Session-restored
    -- buffers can have an EMPTY filetype (restore runs before detection
    -- in some startup paths): re-run detection, then the FileType hook
    -- below starts TS. Normal buffers are untouched (ft already set).
    vim.schedule(function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf)
          and vim.bo[buf].buftype == ''
          and vim.bo[buf].filetype == ''
          and vim.api.nvim_buf_get_name(buf) ~= '' then
          pcall(vim.api.nvim_buf_call, buf, function() vim.cmd('filetype detect') end)
        end
      end
    end)
    -- Start TS whenever a filetype is detected (idempotent).
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
