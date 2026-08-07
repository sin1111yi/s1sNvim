-- plugins/mini-pairs.lua — Auto-pair brackets/quotes (mini.pairs)
-- Loaded on UIEnter (once).
-- Default mappings: () [] {} "" '' `` (auto-close, skip-over, delete pairs).
-- Customize mappings here if needed; see :h mini.pairs.

local U = require('config.util')
return U.try_load('mini.pairs', function(mp)
  mp.setup()
end)
