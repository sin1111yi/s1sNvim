-- plugins/treesitter.lua — Treesitter syntax highlighting
-- Loaded on first BufReadPost (once)

local U = require('config.util')
return U.try_load('nvim-treesitter.configs', function(ts)
  ts.setup({
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = { enable = true },
  })
end)
