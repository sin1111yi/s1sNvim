-- plugins/trigger-help.lua — event-triggered help float (local plugin)
-- Content md files live in docs/trigger-help.nvim/ (user-written, not bundled).
local U = require('config.util')
local help_dir = vim.fn.stdpath('config') .. '/docs/trigger-help.nvim'
return U.try_load('trigger_help', function(t)
  t.setup({
    content = {
      ['/'] = help_dir .. '/search.md',
      ['?'] = help_dir .. '/reverse.md',
      [':'] = help_dir .. '/cmd.md',
      -- 内置 :h 文档形态（替代 md 文件）：
      -- ['?'] = { help = 'search' },
    },
    trigger = 'CmdlineEnter',
    close = 'CmdlineLeave',
  })
end)
