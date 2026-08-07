-- plugins/lualine.lua — Statusline (lazy spec)
-- VeryLazy (equivalent to old UIEnter).
-- Use 'auto' theme so it adapts to whatever colorscheme is active,
-- avoiding race conditions with catppuccin loading.

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  -- catppuccin must apply its colorscheme first: theme='auto' reads the
  -- active colorscheme at setup time, and VeryLazy parallel loading does
  -- not guarantee catppuccin wins the race on its own.
  dependencies = { 'catppuccin/nvim' },
  config = function()
    require('lualine').setup({
      options = {
        theme = 'auto',
        globalstatus = true, -- one statusline across the bottom, showing the current window
        icons_enabled = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
    })
  end,
}
