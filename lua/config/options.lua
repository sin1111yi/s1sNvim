-- config/options.lua — General editor options + startup-critical globals
-- Runs FIRST in init.lua (before lazy bootstrap): leaders and netrw
-- disable must exist before lazy expands <leader> in specs and before
-- nvim 0.12 auto-packadds netrw on directory starts.

local opt = vim.opt

-- Leaders (must precede lazy bootstrap — lazy expands <leader> in specs)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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
-- (no colorcolumn by default; toggle with <leader>rk → 80)

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

-- Netrw (built-in file explorer) — disabled at startup (options runs
-- before lazy bootstrap) so nvim 0.12's auto-packadd of the netrw opt
-- package on `nvim <dir>` hits netrwPlugin.vim's guard and skips loading
-- (otherwise its VimEnter hook E117s netrw#LocalBrowseCheck).
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- When netrw is disabled, `nvim <dir>` no longer auto-cd's into the target
-- directory.  Do it ourselves on VimEnter if argv[0] is a directory.
-- Also capture whether the session was started WITH file/dir args: a
-- wokamark session restore later sources `%argdel`, which zeroes argc —
-- nvim-tree's open decision must use this startup record, not live argc.
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    vim.g.startup_argc = vim.fn.argc() > 0
    local dir = vim.fn.argv(0)
    if dir and dir ~= '' and vim.fn.isdirectory(dir) == 1 then
      vim.cmd('cd ' .. vim.fn.fnameescape(dir))
      -- remember we were opened on a directory (argv may be rewritten by
      -- plugins later, so capture it here at startup)
      vim.g.opened_with_dir = true
      -- absolute startup dir: a wokamark session restore can `cd` elsewhere
      -- (ancestor match on home) — nvim-tree must root back to THIS dir,
      -- not getcwd() which the session may have changed.
      vim.g.startup_dir = vim.fn.fnamemodify(vim.fn.expand(dir), ':p')
    end
  end,
})

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
