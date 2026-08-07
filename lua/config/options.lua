-- config/options.lua — General editor options + startup globals
-- Runs first in init.lua (before lazy bootstrap).

local opt = vim.opt

-- Leaders (must precede lazy bootstrap — lazy expands <leader> in specs)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Line numbers
opt.number = true          -- absolute for current line
opt.relativenumber = true  -- relative elsewhere

-- Indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Display
opt.termguicolors = true
opt.background = 'dark'
opt.cursorline = true
opt.signcolumn = 'yes'
-- (no colorcolumn by default; toggle with <leader>rk)

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Mouse
opt.mouse = 'a'

-- Undo & backup
opt.undofile = true
opt.backup = false
opt.swapfile = false

-- Completion
opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- Netrw is disabled at startup (before nvim 0.12 auto-packadds it on
-- directory starts, which would E117 on its VimEnter hook)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- With netrw disabled, `nvim <dir>` no longer auto-cd's; do it on
-- VimEnter and record startup facts for the tree/layout logic.
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    vim.g.startup_argc = vim.fn.argc() > 0
    local dir = vim.fn.argv(0)
    if dir and dir ~= '' and vim.fn.isdirectory(dir) == 1 then
      vim.cmd('cd ' .. vim.fn.fnameescape(dir))
      vim.g.opened_with_dir = true
      vim.g.startup_dir = vim.fn.fnamemodify(vim.fn.expand(dir), ':p')
    end
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  once = true,
  callback = function()
    vim.g.netrw_banner = 0
    vim.g.netrw_liststyle = 3
  end,
})

-- Clipboard
opt.clipboard = 'unnamedplus'

-- Timeouts
opt.timeoutlen = 500
opt.updatetime = 300

-- Folding
opt.foldmethod = 'expr'
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
opt.foldlevel = 99
