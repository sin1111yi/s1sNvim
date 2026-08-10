-- config/lazy.lua — lazy.nvim bootstrap + setup

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
local stat = vim.uv or vim.loop -- vim.loop is the pre-0.10 name
-- Check the CORE MODULE, not just the dir: a half-cloned dir (interrupted
-- install) would pass a dir-exists check and then fail require('lazy').
local function lazy_installed()
  return stat.fs_stat(lazypath .. '/lua/lazy/init.lua') ~= nil
end
if not lazy_installed() then
  local ret = vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath,
  })
  -- Retry with a plain clone (older git / no partial-clone support)
  if vim.v.shell_error ~= 0 or not lazy_installed() then
    ret = vim.fn.system({
      'git', 'clone',
      'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath,
    })
  end
  if vim.v.shell_error ~= 0 or not lazy_installed() then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { ret, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
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
  -- Git ops (install/update) timeout in seconds; slow networks / Windows
  -- need more headroom than the 60s default.
  git = { timeout = 300 },
  checker = { enabled = false },
  change_detection = { notify = false },
})

-- Config updates are MANUAL: <leader>xu opens a terminal, runs
-- git pull with live output, then notifies. No startup auto-pull.
