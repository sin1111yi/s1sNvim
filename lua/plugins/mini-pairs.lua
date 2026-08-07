-- plugins/mini-pairs.lua — Auto-pair brackets/quotes (mini.pairs, lazy spec)
-- VeryLazy (equivalent to old UIEnter); paired before first InsertEnter.
-- Default mappings: () [] {} "" '' `` (auto-close, skip-over, delete pairs).
-- Customize mappings here if needed; see :h mini.pairs.

return {
  'echasnovski/mini.pairs',
  event = 'VeryLazy',
  commit = 'b1c5a726921b7a8c9321e9a7a208aa0571de5810', -- migration pin
  config = function()
    require('mini.pairs').setup()
  end,
}
