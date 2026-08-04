-- config/autocmds.lua — Autocommands + event-driven plugin lazy loaders
-- Each plugin has its own file under lua/plugins/ and is loaded on the
-- first event where it's actually needed. All loaders use once=true.

local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

--------------------------------------------------------------------
-- 1. Built-in general autocmds (no plugin dependencies)
--------------------------------------------------------------------

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

-- Save when focus leaves the nvim window
au('FocusLost', {
  group = gen, pattern = '*',
  callback = autosave,
})

-- Save when leaving the current buffer (switching files/tabs/etc.)
au('BufLeave', {
  group = gen, pattern = '*',
  callback = autosave,
})

-- Save when leaving insert mode
au('InsertLeave', {
  group = gen, pattern = '*',
  callback = autosave,
})

--------------------------------------------------------------------
-- 2. Plugin lazy loaders — each triggers the corresponding file
--    under lua/plugins/ on the first occurrence of its event.
--------------------------------------------------------------------

-- Colorscheme
au('UIEnter', {
  group = augroup('PluginColorscheme', { clear = true }),
  once = true,
  callback = function() require('plugins.catppuccin') end,
})

-- Treesitter
au('BufReadPost', {
  group = augroup('PluginTreesitter', { clear = true }),
  once = true,
  callback = function() require('plugins.treesitter') end,
})

-- Lualine (statusline)
au('UIEnter', {
  group = augroup('PluginLualine', { clear = true }),
  once = true,
  callback = function() require('plugins.lualine') end,
})

-- Dressing (vim.ui.select/input floating windows)
au('UIEnter', {
  group = augroup('PluginDressing', { clear = true }),
  once = true,
  callback = function() require('plugins.dressing') end,
})

-- Bufferline (buffer tab bar)
au('UIEnter', {
  group = augroup('PluginBufferline', { clear = true }),
  once = true,
  callback = function() require('plugins.bufferline') end,
})

-- Persistence (session auto save/restore)
au('UIEnter', {
  group = augroup('PluginPersistence', { clear = true }),
  once = true,
  callback = function() require('plugins.persistence') end,
})

-- NvimTree (file explorer)
au('UIEnter', {
  group = augroup('PluginNvimTree', { clear = true }),
  once = true,
  callback = function() require('plugins.nvim-tree') end,
})

-- Which-key (key binding management)
au('UIEnter', {
  group = augroup('PluginWhichkey', { clear = true }),
  once = true,
  callback = function() require('plugins.which-key') end,
})

-- Plugin keymaps (centralized; loaded after which-key so wk is ready)
au('UIEnter', {
  group = augroup('PluginKeymaps', { clear = true }),
  once = true,
  callback = function() require('plugins.custom.plugin-keymaps') end,
})

-- Devicons (file type icons — loaded first so others can use them)
au('UIEnter', {
  group = augroup('PluginDevicons', { clear = true }),
  once = true,
  callback = function() require('plugins.devicons') end,
})

-- Mini.icons (lightweight icon provider)
au('UIEnter', {
  group = augroup('PluginMiniIcons', { clear = true }),
  once = true,
  callback = function() require('plugins.mini-icons') end,
})

-- Gitsigns + Comment (both trigger on first real file open)
au('BufReadPost', {
  group = augroup('PluginGitsigns', { clear = true }),
  once = true,
  callback = function()
    require('plugins.gitsigns')
    require('plugins.comment')
  end,
})

-- nvim-cmp (autocompletion)
au('InsertEnter', {
  group = augroup('PluginCmp', { clear = true }),
  once = true,
  callback = function() require('plugins.cmp') end,
})

-- LSP (Mason + lspconfig)
local lsp_filetypes = {
  'rust', 'c', 'cpp', 'lua', 'python',
  'toml', 'yaml', 'json', 'markdown', 'sh', 'bash',
}
au('FileType', {
  group = augroup('PluginLsp', { clear = true }),
  once = true,
  pattern = lsp_filetypes,
  callback = function() require('plugins.lsp') end,
})
