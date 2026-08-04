-- plugins/nvim-tree.lua — File explorer (nvim-tree)
-- Loaded on UIEnter (once).
-- Persistent sidebar tree. <leader>m toggles it.

local U = require('config.util')
return U.try_load('nvim-tree', function()
  -- Disable built-in netrw explorer (required before nvim-tree loads)
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  require('nvim-tree').setup({
    view = { width = 30 },
    renderer = { group_empty = true },
    experimental = {
      -- Restore nvim-tree buffers when restoring vim sessions
      session_restore_nvim = true,
    },
  })

  -- Auto-open on startup (this file loads at UIEnter, UI is already ready),
  -- then return focus to the edit window
  vim.cmd('NvimTreeOpen')
  vim.cmd('wincmd p')
end)
