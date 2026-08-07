-- plugins/catppuccin.lua — Colorscheme (lazy spec)
-- VeryLazy (equivalent to old UIEnter). setup + colorscheme application
-- happen in config (plugin is guaranteed loaded by then — replaces
-- util.set_colorscheme's UIEnter retry logic).

return {
  'catppuccin/nvim',
  event = 'VeryLazy',
  config = function()
    require('catppuccin').setup({})
    vim.cmd.colorscheme('catppuccin-mocha')
  end,
}
