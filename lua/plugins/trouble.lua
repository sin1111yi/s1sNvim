-- plugins/trouble.lua — Diagnostics / quickfix / location list (trouble.nvim, lazy spec)
-- VeryLazy (equivalent to old UIEnter); <leader>xx/xq/xL closures
-- require('trouble') so the plugin must be loaded by then.
-- Keymaps in plugins/custom/plugin-keymaps.lua.

return {
  'folke/trouble.nvim',
  event = 'VeryLazy',
  commit = 'bd67efe408d4816e25e8491cc5ad4088e708a69a', -- migration pin
  config = function()
    require('trouble').setup({})
  end,
}
