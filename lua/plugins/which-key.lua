-- plugins/which-key.lua — Key binding management (v3 API)
-- Loaded on UIEnter (once).
-- All mappings are registered in plugins/custom/plugin-keymaps.lua.

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

return true
