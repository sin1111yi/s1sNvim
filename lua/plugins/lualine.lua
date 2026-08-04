-- plugins/lualine.lua — Statusline
-- Loaded on UIEnter (once).
-- Use 'auto' theme so it adapts to whatever colorscheme is active,
-- avoiding race conditions with catppuccin loading.

local U = require('config.util')
return U.try_load('lualine', function(ll)
  ll.setup({
    options = {
      theme = 'auto',
      icons_enabled = true,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
    },
  })
end)
