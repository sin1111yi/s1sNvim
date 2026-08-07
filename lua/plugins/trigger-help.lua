-- plugins/trigger-help.lua — command-triggered help panel (GitHub install, lazy spec)
-- Eager (no lazy trigger): wokamark's setup() calls register_doc, and
-- :TriggerHelp must be available right away. Content md files live in
-- docs/trigger-help.nvim/ (user-written, not bundled).
-- :TriggerHelp             toggle: 关闭面板 / 打开 snacks picker 浏览
-- :TriggerHelp <name>      直接打开（content 键 > md 文件名 > help tag）

return {
  'sin1111yi/trigger-help.nvim',
  config = function()
    local help_dir = vim.fn.stdpath('config') .. '/docs/trigger-help.nvim'
    require('trigger_help').setup({
      content = {
        search = help_dir .. '/search.md',
        reverse = help_dir .. '/reverse.md',
        cmd = help_dir .. '/cmd.md',
      },
      height = 40,         -- 面板高度（窗口高度百分比）
      position = 'bottom', -- 'bottom' | 'top'
    })
  end,
}
