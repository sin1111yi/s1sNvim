-- plugins/illuminate.lua — Highlight word under cursor across the buffer
-- Loaded on UIEnter (once).
-- Shows every occurrence of the word under the cursor (no LSP needed).

local U = require('config.util')
return U.try_load('illuminate', function(il)
  il.configure({
    delay = 120,          -- ms after cursor stops before highlighting
    under_cursor = false, -- don't highlight the word under the cursor itself
    filetypes_denylist = {
      'NvimTree', 'help', 'toggleterm', 'TelescopePrompt',
      'alpha', 'dashboard', 'lazy', 'mason', 'checkhealth',
    },
  })
end)
