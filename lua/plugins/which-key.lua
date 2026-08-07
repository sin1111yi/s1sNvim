-- plugins/which-key.lua — Key binding management (v3 API, lazy spec)
-- VeryLazy (equivalent to old UIEnter). All mappings are registered in
-- plugins/custom/plugin-keymaps.lua — loaded here so setup → add order
-- is preserved (single registration point, ADR D-001).

return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  commit = '3aab2147e74890957785941f0c1ad87d0a44c15a', -- migration pin
  config = function()
    local wk = require('which-key')

    wk.setup({
      preset = 'classic',
      delay = function(ctx)
        return ctx.plugin and 0 or 200
      end,
      icons = { mappings = true, colors = true },
      plugins = {
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
    })

    -- All keybindings registered centrally (must run after wk.setup)
    require('plugins.custom.plugin-keymaps')
  end,
}
