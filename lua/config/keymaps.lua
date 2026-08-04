-- config/keymaps.lua — Key mappings (non-Leader)
-- <Leader>-prefixed mappings live in plugins/which-key.lua.

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Insert mode: exit with jk/kj
keymap('i', 'jk', '<Esc>', opts)
keymap('i', 'kj', '<Esc>', opts)

-- Normal mode: centered search
keymap('n', 'n', 'nzzzv', opts)
keymap('n', 'N', 'Nzzzv', opts)
keymap('n', '*', '*zzzv', opts)
keymap('n', '#', '#zzzv', opts)
keymap('n', 'J', 'mzJ`z', opts)

-- Yank to end of line (consistent with D, C)
keymap('n', 'Y', 'y$', opts)

-- Visual mode: preserve selection on indent
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- Split navigation
keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-j>', '<C-w>j', opts)
keymap('n', '<C-k>', '<C-w>k', opts)
keymap('n', '<C-l>', '<C-w>l', opts)

-- Split resize
keymap('n', '<A-Up>', '<C-w>+', opts)
keymap('n', '<A-Down>', '<C-w>-', opts)
keymap('n', '<A-Left>', '<C-w><', opts)
keymap('n', '<A-Right>', '<C-w>>', opts)

-- Tab navigation (not Leader-prefixed)
keymap('n', '<Tab>', ':tabnext<CR>', opts)
keymap('n', '<S-Tab>', ':tabprevious<CR>', opts)

-- Clear search highlight
keymap('n', '<Esc>', ':nohlsearch<CR><Esc>', opts)
