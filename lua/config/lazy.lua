-- config/lazy.lua — lazy.nvim bootstrap + setup

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- One spec file per plugin under lua/plugins/
  spec = {
    { import = 'plugins' },
  },
  -- Own plugins (github.com/sin1111yi/*) load from ~/Development when
  -- present, else fall back to GitHub install.
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
-- git pull with live output, then notifies. No startup auto-pull.
