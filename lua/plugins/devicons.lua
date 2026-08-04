-- plugins/devicons.lua — File type icons (nvim-tree/nvim-web-devicons)
-- Loaded on UIEnter before lualine/which-key/dressing so they
-- can use file-type icons. No setup needed — requiring is enough.

local U = require('config.util')
return U.try_load('nvim-web-devicons')
