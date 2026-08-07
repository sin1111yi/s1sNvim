-- plugins/toggleterm.lua — Terminal toggle (toggleterm.nvim, lazy spec)
-- cmd-triggered (lazier than old UIEnter: first :ToggleTerm press loads).
-- Keymaps in plugins/custom/plugin-keymaps.lua (<leader>tt/tv/tf).

return {
  'akinsho/toggleterm.nvim',
  cmd = 'ToggleTerm',
  config = function()
    require('toggleterm').setup({
      size = 12,
      open_mapping = false, -- no default mapping; we bind <leader>tt ourselves
      direction = 'horizontal',
      shade_terminals = true,
      float_opts = { border = 'curved' },
    })
  end,
}
