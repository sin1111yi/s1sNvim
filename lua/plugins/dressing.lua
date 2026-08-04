-- plugins/dressing.lua — UI enhancement (vim.ui.select/input)
-- Loaded on UIEnter to upgrade all select/input prompts to floating windows.

local U = require('config.util')
return U.try_load('dressing', function(d)
  d.setup({
    input = {
      relative = 'cursor',
      prefer_width = 50,
    },
    select = {
      backend = { 'builtin' },
      format_item_override = {},
    },
  })
end)
