-- init.lua — Neovim entry point
-- Built-in plugin manager: vim.pack (Neovim 0.12+)
-- Modular config under lua/config/
-- Plugins are loaded lazily by event-driven autocmds in config.autocmds.

vim.loader.enable()

-- Plugin declarations must run first. vim.pack.add() parses specs and
-- prepares for install; plugins are NOT loaded until required by autocmds.
require('config.plugins')

-- Shared helpers (try_load, set_colorscheme)
require('config.util')

-- Core config — no plugin dependencies, safe to run immediately.
require('config.options')
require('config.keymaps')

-- Autocommands — includes both built-in autocmds and event-driven
-- plugin lazy loaders (Treesitter, Lualine, Which-key, Gitsigns,
-- Comment, nvim-cmp, LSP, colorscheme).
require('config.autocmds')
