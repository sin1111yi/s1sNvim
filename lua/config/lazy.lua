-- config/lazy.lua — lazy.nvim bootstrap + setup options
-- Bootstrap: clone lazy.nvim (stable branch) on first run, prepend to rtp.
-- Setup options per ADR-002 (D-001/D-004/D-007):
--   spec    = import 'plugins'  — one spec file per plugin under lua/plugins/
--   dev     = ~/projects for github.com/sin1111yi/* (wokamark/trigger-help),
--             fallback to GitHub install when the dir is missing
--   install = colorscheme so first-install UI doesn't flash the default theme
--   checker = disabled — explicit :Lazy update only (user preference)

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Phase 1 (bootstrap): empty spec — lua/plugins/*.lua are still vim.pack
  -- era try_load wrappers and must not be parsed as lazy specs yet.
  -- Phase 2 switches to { import = 'plugins' } once all files are spec'd.
  spec = {},
  dev = {
    path = '~/projects',
    patterns = { 'github.com/sin1111yi/' },
    fallback = true,
  },
  install = { colorscheme = { 'catppuccin-mocha' } },
  checker = { enabled = false },
  change_detection = { notify = false },
})
