-- plugins/toggleterm.lua — Terminal toggle (toggleterm.nvim)
-- Loaded on UIEnter (once).
-- Keymaps in plugins/custom/plugin-keymaps.lua (<leader>tt/tv/tf).

local U = require('config.util')
return U.try_load('toggleterm', function(tt)
  tt.setup({
    size = 12,
    open_mapping = false, -- no default mapping; we bind <leader>tt ourselves
    direction = 'horizontal',
    shade_terminals = true,
    float_opts = { border = 'curved' },
  })
end)
