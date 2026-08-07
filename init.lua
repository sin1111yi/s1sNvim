-- init.lua — Neovim entry point
-- Plugin manager: lazy.nvim (ADR-002). Bootstrap must run FIRST so specs
-- are parsed and eager plugins (wokamark/trigger-help) load before
-- VimEnter. Core config (options/keymaps/autocmds) has no plugin
-- dependencies and runs after.

vim.loader.enable()

-- Leaders MUST be set before lazy bootstrap: lazy expands <leader>/<localleader>
-- in specs at setup time (defaulting to '\' when unset), so defining them here
-- keeps every mapping consistent.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable netrw BEFORE anything can load it: nvim 0.12 auto-packadds the
-- netrw opt package for directory starts (`nvim <dir>`), whose VimEnter
-- hook would call netrw#LocalBrowseCheck() and E117 once autoload is
-- blocked. Setting these here (pre-bootstrap) lets netrwPlugin.vim's own
-- guard skip loading entirely.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Lazy plugin manager bootstrap (installs lazy.nvim on first run)
require('config.lazy')

-- Core config — no plugin dependencies, safe to run immediately.
require('config.options')
require('config.keymaps')

-- Built-in general autocmds (edit behaviour, auto-save, etc.)
require('config.autocmds')
