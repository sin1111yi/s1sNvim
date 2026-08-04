-- plugins/persistence.lua — Session persistence (auto save/restore)
-- Loaded on UIEnter (once). Auto-save happens on exit (VimLeavePre, built-in
-- to persistence). Auto-restore: persistence never restores by itself, so we
-- load the current directory's session here — this loader runs inside the
-- UIEnter callback, BEFORE the nvim-tree loader (see autocmds.lua order),
-- so buffers/layout restore first, then the tree opens on top.

local U = require('config.util')
return U.try_load('persistence', function(p)
  p.setup({})

  -- Restore session for this directory if one exists (no-op otherwise)
  pcall(require('persistence').load)
end)
