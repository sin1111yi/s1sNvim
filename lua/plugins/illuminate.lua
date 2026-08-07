-- plugins/illuminate.lua — Highlight word under cursor across the buffer (lazy spec)
-- VeryLazy (equivalent to old UIEnter).
-- Shows every occurrence of the word under the cursor (no LSP needed).

return {
  'RRethy/vim-illuminate',
  event = 'VeryLazy',
  commit = '91313e598ca62e110bc71535c49069b66b9883c9', -- migration pin
  config = function()
    require('illuminate').configure({
      delay = 120,          -- ms after cursor stops before highlighting
      under_cursor = false, -- don't highlight the word under the cursor itself
      filetypes_denylist = {
        'NvimTree', 'help', 'toggleterm', 'TelescopePrompt',
        'alpha', 'dashboard', 'lazy', 'mason', 'checkhealth',
      },
    })
  end,
}
