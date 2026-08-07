-- plugins/catppuccin.lua — Colorscheme (lazy spec)
-- VeryLazy (equivalent to old UIEnter). setup + colorscheme application
-- happen in config (plugin is guaranteed loaded by then — replaces
-- util.set_colorscheme's UIEnter retry logic).

return {
  'catppuccin/nvim',
  event = 'VeryLazy',
  commit = '05e8787020dcfdb937bf2ff23855ea2415b4e072', -- migration pin
  config = function()
    require('catppuccin').setup({})
    vim.cmd.colorscheme('catppuccin-mocha')
  end,
}
