-- plugins/flash.lua — Flash jump navigation
-- Loaded on UIEnter (once).
-- s jumps to a two-char label across the screen, S jumps in treesitter
-- scope. Keymaps declared in plugins/custom/plugin-keymaps.lua.

local U = require('config.util')
return U.try_load('flash', function(flash)
  flash.setup({
    modes = {
      char = {
        -- show jump labels on f/F/t/T (default false: incremental only)
        jump_labels = true,
      },
    },
  })
end)
