-- plugins/trigger-help.lua — event-triggered help float (local plugin)
-- Content md files live in docs/trigger-help.nvim/ (user-written, not bundled).
local U = require('config.util')
return U.try_load('trigger_help', function(t)
  t.setup({
    content = {
      ['/'] = '~/.config/nvim/docs/trigger-help.nvim/search.md',
      ['?'] = '~/.config/nvim/docs/trigger-help.nvim/reverse.md',
      [':'] = '~/.config/nvim/docs/trigger-help.nvim/cmd.md',
      -- 内置 :h 文档形态（替代 md 文件）：
      -- ['?'] = { help = 'search' },
    },
    trigger = 'CmdlineEnter',
    close = 'CmdlineLeave',
  })
end)
