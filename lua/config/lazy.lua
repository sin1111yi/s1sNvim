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
  -- One spec file per plugin under lua/plugins/ (import scans top level
  -- only; lua/plugins/custom/ is NOT imported — required explicitly by
  -- config functions, ADR D-001).
  spec = {
    { import = 'plugins' },
  },
  dev = {
    path = '~/Development',
    patterns = { 'github.com/sin1111yi/' },
    fallback = true,
  },
  install = { colorscheme = { 'catppuccin-mocha' } },
  checker = { enabled = false },
  change_detection = { notify = false },
})

-- Config updates are MANUAL: <leader>xu opens a terminal, runs
-- git pull with live output, then restarts nvim. No startup auto-pull
-- (avoids network + surprise reloads on every boot).
