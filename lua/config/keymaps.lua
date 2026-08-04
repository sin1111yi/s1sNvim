-- config/keymaps.lua — Key mappings (non-Leader)
-- <Leader>-prefixed mappings live in plugins/custom/plugin-keymaps.lua.

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Insert mode: exit with jk/kj (Esc also works natively)
keymap('i', 'jk', '<Esc>', opts)
keymap('i', 'kj', '<Esc>', opts)

-- Normal mode: centered search
keymap('n', 'n', 'nzzzv', opts)
keymap('n', 'N', 'Nzzzv', opts)
keymap('n', '*', '*zzzv', opts)
keymap('n', '#', '#zzzv', opts)

-- Clear search highlight
keymap('n', '<Esc>', ':nohlsearch<CR><Esc>', opts)
