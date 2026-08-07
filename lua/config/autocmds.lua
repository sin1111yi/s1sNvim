-- config/autocmds.lua — Built-in general autocmds
-- Plugin lazy loading is handled by lazy.nvim (see lua/config/lazy.lua)

local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local gen = augroup('General', { clear = true })

-- Return to last edit position when reopening a file
au('BufReadPost', {
  group = gen, pattern = '*',
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lc = mark[1]
    if lc > 1 and lc <= vim.api.nvim_buf_line_count(args.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Highlight yanked text briefly
au('TextYankPost', {
  group = gen, pattern = '*',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
  end,
})

-- Auto-resize splits on window resize
au('VimResized', {
  group = gen, pattern = '*',
  command = 'tabdo wincmd =',
})

-- Disable line numbers and cursorline in terminal buffers
au('TermOpen', {
  group = gen, pattern = '*',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.cursorline = false
    vim.cmd('startinsert')
  end,
})

-- Spell-check for specific filetypes
au('FileType', {
  group = gen,
  pattern = { 'markdown', 'text', 'gitcommit' },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- Format on save (opt-in per buffer: vim.b.autoformat = true)
au('BufWritePre', {
  group = gen, pattern = '*',
  callback = function(args)
    if vim.b[args.buf] and vim.b[args.buf].autoformat then
      vim.lsp.buf.format({ bufnr = args.buf })
    end
  end,
})

-- Auto-save current buffer (only real files with pending changes)
local function autosave()
  if vim.bo.modified and vim.bo.buftype == '' and vim.fn.expand('%') ~= '' then
    vim.cmd('silent! write')
  end
end

au('FocusLost', { group = gen, pattern = '*', callback = autosave })
au('BufLeave', { group = gen, pattern = '*', callback = autosave })
au('InsertLeave', { group = gen, pattern = '*', callback = autosave })
