-- plugins/trigger-help.lua — event-triggered help float (local plugin)
-- Content md files live in ~/.config/nvim/keyhelp/ (user-written, not bundled).
local U = require('config.util')
return U.try_load('trigger_help', function(t)
  t.setup({
    content = {
      ['/'] = '~/.config/nvim/keyhelp/search.md',
      ['?'] = '~/.config/nvim/keyhelp/reverse.md',
      [':'] = '~/.config/nvim/keyhelp/cmd.md',
      -- 内置 :h 文档形态（替代 md 文件）：
      -- ['?'] = { help = 'search' },
    },
    trigger = 'CmdlineEnter',
    close = 'CmdlineLeave',
  })
end)
