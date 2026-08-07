-- plugins/mini-surround.lua — Surround text objects (mini.surround, lazy spec)
-- VeryLazy (equivalent to old UIEnter).
-- Mappings use ( prefix (free, only native sentence-move command):
--   (s = add surround, (d = delete, (r = replace
--   (f = find right surround, (F = find left surround
-- find/find_left are left empty: their default gs/gS conflict with flash.

return {
  'echasnovski/mini.surround',
  event = 'VeryLazy',
  commit = '8d5d0c5aa92449368ac251e85451d79d8f69d296', -- migration pin
  config = function()
    require('mini.surround').setup({
      mappings = {
        add = '(s',
        delete = '(d',
        replace = '(r',
        find = '(f',
        find_left = '(F',
      },
    })
  end,
}
