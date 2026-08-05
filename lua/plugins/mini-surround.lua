-- plugins/mini-surround.lua — Surround text objects (mini.surround)
-- Loaded on UIEnter (once).
-- Mappings use nvim-surround style (ys/ds/cs) so `s` stays free for flash.

local U = require('config.util')
return U.try_load('mini.surround', function(ms)
  ms.setup({
    mappings = {
      add = 'ys',
      delete = 'ds',
      replace = 'cs',
      find = 'gs',
      find_left = 'gS',
    },
  })
end)
