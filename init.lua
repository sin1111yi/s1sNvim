-- init.lua — Neovim entry point
-- Load order matters:
--   1. options first — early globals (leader, netrw disable) must exist
--      BEFORE lazy bootstrap: lazy expands <leader> at setup time and
--      nvim 0.12 auto-packadds netrw for directory starts. options.lua
--      has no plugin dependencies, safe to run first.
--   2. lazy bootstrap (specs parsed, eager plugins load)
--   3. keymaps / autocmds (no plugin dependencies)

vim.loader.enable()

-- Core config first: leaders + netrw disable + editor options.
require('config.options')

-- Lazy plugin manager bootstrap (installs lazy.nvim on first run)
require('config.lazy')

-- Key mappings (non-Leader)
require('config.keymaps')

-- Built-in general autocmds (edit behaviour, auto-save, etc.)
require('config.autocmds')
