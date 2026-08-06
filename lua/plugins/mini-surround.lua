-- plugins/mini-surround.lua — Surround text objects (mini.surround)
-- Loaded on UIEnter (once).
-- Mappings use ( prefix (free, only native sentence-move command):
--   (s = add surround, (d = delete, (r = replace
--   (f = find right surround, (F = find left surround
-- find/find_left are left empty: their default gs/gS conflict with flash.

local U = require('config.util')
return U.try_load('mini.surround', function(ms)
  ms.setup({
    mappings = {
      add = '(s',
      delete = '(d',
      replace = '(r',
      find = '(f',
      find_left = '(F',
    },
  })
end)
