-- plugins/trouble.lua — Diagnostics / quickfix / location list (trouble.nvim)
-- Loaded on UIEnter (once).
-- Keymaps in plugins/custom/plugin-keymaps.lua (<leader>xx/xq/xL).

local U = require('config.util')
return U.try_load('trouble', function(trouble)
  trouble.setup({})
end)
