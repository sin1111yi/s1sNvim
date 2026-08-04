-- plugins/mini-starter.lua — Startup dashboard (mini.starter)
-- Loaded on UIEnter (once).
-- MiniStarter normally auto-opens on VimEnter, but since it's lazy-loaded at
-- UIEnter (VimEnter has already fired), we trigger open manually when Neovim
-- was started with no file arguments.

local U = require('config.util')
return U.try_load('mini.starter', function(ms)
  ms.setup({})
  -- Trigger the startup dashboard manually (VimEnter has already passed).
  -- Only open when no file arguments were given (argc == 0), so `nvim file`
  -- still opens the file directly.
  vim.schedule(function()
    if vim.fn.argc() == 0 then
      pcall(ms.open)
    end
  end)
end)
