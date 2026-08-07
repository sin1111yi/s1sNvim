-- plugins/flash.lua — Flash jump navigation (lazy spec)
-- VeryLazy so f/F/t/T jump labels are active from startup.
-- s jumps to a two-char label across the screen, S jumps in treesitter
-- scope. Keymaps declared in plugins/custom/plugin-keymaps.lua.

return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  commit = 'b6346946d10d07998efee029fb0f7a593806d0cd', -- migration pin
  config = function()
    require('flash').setup({
      modes = {
        char = {
          -- show jump labels on f/F/t/T (default false: incremental only)
          jump_labels = true,
        },
      },
    })
  end,
}
