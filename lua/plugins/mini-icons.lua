-- plugins/mini-icons.lua — Lightweight icon provider (mini.icons, lazy spec)
-- VeryLazy; used by which-key for icon rules when devicons don't cover
-- something. No setup needed — mini.icons is lazy by design.

return {
  'echasnovski/mini.icons',
  event = 'VeryLazy',
  commit = '98faae31e9be1cc054ae63485e58ceb185efcad0', -- migration pin
}
