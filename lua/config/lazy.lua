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
    path = '~/projects',
    patterns = { 'github.com/sin1111yi/' },
    fallback = true,
  },
  install = { colorscheme = { 'catppuccin-mocha' } },
  checker = { enabled = false },
  change_detection = { notify = false },
})

-- Config auto-update: pull the config repo from GitHub on every startup.
-- NOTE: User LazyDone fires INSIDE lazy.setup() (lazy/init.lua:115), so an
-- autocmd registered after setup() never sees it — use UIEnter instead,
-- which reliably runs once after startup completes (covers :Lazy update,
-- which also ends in a normal startup/UIEnter path).
-- Only pull when the working tree is clean (never clobber local edits).
vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    local cfg = vim.fn.stdpath('config')
    -- bail out silently when not a git checkout (e.g. dev install)
    if vim.fn.isdirectory(cfg .. '/.git') ~= 1 and vim.fn.filereadable(cfg .. '/.git') ~= 1 then
      return
    end
    local dirty = vim.fn.system({ 'git', '-C', cfg, 'status', '--porcelain' }):gsub('%s+', '')
    if dirty ~= '' then
      vim.notify('Config repo has local changes — skipping auto-pull', vim.log.levels.WARN)
      return
    end
    vim.schedule(function()
      local out = vim.fn.system({ 'git', '-C', cfg, 'pull', '--ff-only', 'origin', 'main' })
      if vim.v.shell_error ~= 0 then
        vim.notify('Config auto-pull failed: ' .. out, vim.log.levels.ERROR)
      elseif out:match('Already up to date') then
        -- silent: nothing new
      else
        vim.notify('Config updated from GitHub — restart nvim to apply', vim.log.levels.INFO)
      end
    end)
  end,
})
