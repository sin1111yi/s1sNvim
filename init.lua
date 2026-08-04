-- init.lua — Neovim entry point
-- Built-in plugin manager: vim.pack (Neovim 0.12+)
-- Modular config under lua/config/
-- Plugins are loaded lazily by event-driven autocmds in custom/utils/loader.lua

vim.loader.enable()

-- Plugin declarations must run first. vim.pack.add() parses specs and
-- prepares for install; plugins are NOT loaded until required by loader.
require('config.plugins')

-- Shared helpers (try_load, set_colorscheme)
require('config.util')

-- Core config — no plugin dependencies, safe to run immediately.
require('config.options')
require('config.keymaps')

-- Plugin lazy loader (registers event-driven autocmds before UIEnter)
require('config.loader')

-- Built-in general autocmds (edit behaviour, auto-save, etc.)
require('config.autocmds')
