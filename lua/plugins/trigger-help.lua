-- plugins/trigger-help.lua — command-triggered help panel (local plugin)
-- :TriggerHelp             toggle: 关闭面板 / 打开 snacks picker 浏览
-- :TriggerHelp <name>      直接打开（content 键 > md 文件名 > help tag）
-- Content md files live in docs/trigger-help.nvim/ (user-written, not bundled).
local U = require('config.util')
local help_dir = vim.fn.stdpath('config') .. '/docs/trigger-help.nvim'
return U.try_load('trigger_help', function(t)
  t.setup({
    content = {
      search = help_dir .. '/search.md',
      reverse = help_dir .. '/reverse.md',
      cmd = help_dir .. '/cmd.md',
    },
    height = 40,        -- 面板高度（窗口高度百分比）
    position = 'bottom', -- 'bottom' | 'top'
  })
end)
