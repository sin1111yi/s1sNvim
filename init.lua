-- init.lua — Neovim entry point
-- Plugin manager: lazy.nvim (ADR-002). Bootstrap must run FIRST so specs
-- are parsed and eager plugins (wokamark/trigger-help) load before
-- VimEnter. Core config (options/keymaps/autocmds) has no plugin
-- dependencies and runs after.

vim.loader.enable()

-- Lazy plugin manager bootstrap (installs lazy.nvim on first run)
require('config.lazy')

-- Core config — no plugin dependencies, safe to run immediately.
require('config.options')
require('config.keymaps')

-- Built-in general autocmds (edit behaviour, auto-save, etc.)
require('config.autocmds')
