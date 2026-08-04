-- config/options.lua — General editor options
-- All settings use vim.opt (Lua API for :set)

local opt = vim.opt

-- Line numbers
opt.number = true          -- Show absolute line number for current line
opt.relativenumber = true  -- Show relative line numbers elsewhere

-- Indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true        -- Spaces instead of tabs
opt.smartindent = true

-- Search
opt.hlsearch = true         -- Highlight search results
opt.incsearch = true        -- Incremental search
opt.ignorecase = true       -- Case-insensitive search
opt.smartcase = true        -- ...unless uppercase is used

-- Display
opt.termguicolors = true    -- 24-bit RGB color support
opt.background = 'dark'
opt.cursorline = true       -- Highlight current line
opt.signcolumn = 'yes'      -- Always show sign column
opt.colorcolumn = '100'     -- Highlight long lines

-- Splits
opt.splitright = true       -- Vertical split opens to the right
opt.splitbelow = true       -- Horizontal split opens below

-- Mouse
opt.mouse = 'a'             -- Enable mouse in all modes

-- Undo & backup
opt.undofile = true         -- Persistent undo
opt.backup = false
opt.swapfile = false

-- Completion
opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- Netrw (built-in file explorer) — disabled at startup so `nvim .` doesn't
-- open it before nvim-tree (lazy-loaded) takes over. Also lazy init via autocmd.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  once = true,
  callback = function()
    vim.g.netrw_banner = 0
    vim.g.netrw_liststyle = 3   -- Tree view
  end,
})

-- Clipboard — use system clipboard via best available provider.
-- Neovim auto-detects: GUI > OSC52 terminal support (0.11+) > xclip/xsel/wl-clipboard.
opt.clipboard = 'unnamedplus'

-- Timeouts
opt.timeoutlen = 500        -- Time to wait for mapped key sequence (ms)
opt.updatetime = 300        -- CursorHold interval (ms)

-- Folding
opt.foldmethod = 'expr'
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
opt.foldlevel = 99
