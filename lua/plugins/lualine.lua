-- plugins/lualine.lua — Statusline (lazy spec)
-- VeryLazy (equivalent to old UIEnter).
-- Use 'auto' theme so it adapts to whatever colorscheme is active,
-- avoiding race conditions with catppuccin loading.

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  commit = '221ce6b2d999187044529f49da6554a92f740a96', -- migration pin
  config = function()
    require('lualine').setup({
      options = {
        theme = 'auto',
        icons_enabled = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
    })
  end,
}
