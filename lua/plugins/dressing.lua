-- plugins/dressing.lua — UI enhancement (vim.ui.select/input, lazy spec)
-- VeryLazy to upgrade all select/input prompts to floating windows.

return {
  'stevearc/dressing.nvim',
  event = 'VeryLazy',
  commit = '2d7c2db2507fa3c4956142ee607431ddb2828639', -- migration pin
  config = function()
    require('dressing').setup({
      input = {
        relative = 'cursor',
        prefer_width = 50,
      },
      select = {
        backend = { 'builtin' },
        format_item_override = {},
      },
    })
  end,
}
