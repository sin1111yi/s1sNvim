-- config/treesitter-langs.lua — shared parser language list
-- Used by:
--   1. plugins/treesitter.lua (build: install on plugin install/update)
--   2. config/lazy.lua (User LazyDone: ensure parsers after every update)
-- Install is idempotent — already-installed parsers are skipped quickly.

return {
  'lua', 'vim', 'vimdoc', -- this config itself
  'rust', 'c', 'cpp', 'python', 'go', -- dev languages
  'bash', 'json', 'toml', 'yaml', 'markdown', -- config/data
  'html', 'css', 'javascript', 'typescript', -- web
  'make', 'cmake', -- build tooling
}
