-- plugins/mini-icons.lua — Lightweight icon provider (mini.icons)
-- Used by which-key for icon rules when devicons don't cover something.
-- No setup needed — mini.icons is lazy by design.

local U = require('config.util')
return U.try_load('mini.icons')
