-- plugins/devicons.lua — File type icons (nvim-tree/nvim-web-devicons, lazy spec)
-- VeryLazy so lualine/which-key/dressing can use file-type icons.
-- No setup needed — requiring is enough. bufferline pulls it via deps too.

return {
  'nvim-tree/nvim-web-devicons',
  event = 'VeryLazy',
  commit = 'dad71387de386a946b123079d0e53f23028f3abd', -- migration pin
}
