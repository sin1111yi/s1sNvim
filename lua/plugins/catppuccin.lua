-- plugins/catppuccin.lua — Colorscheme
-- Loaded on UIEnter (once)

local U = require('config.util')
U.try_load('catppuccin', function(cp) cp.setup({}) end)
U.set_colorscheme('catppuccin-mocha')

return true
