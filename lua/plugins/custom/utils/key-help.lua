-- plugins/custom/utils/key-help.lua — per-command help overlay
-- When the user starts typing a command (/ ? : etc), show a floating
-- help window in the top-right corner with that command's usage.
-- The window closes automatically when the command line is left
-- (Enter to confirm, Esc/Ctrl-C to cancel).

local M = {}

-- command-type char -> lines of help text
local HELP = {
  ['/'] = {
    '  / 搜索 — 基本用法',
    '',
    '  /foo        向后搜索 foo',
    '  n / N       下一个 / 上一个',
    '  * / #       光标下单词搜索（向后/向前）',
    '  /foo\\c      忽略大小写',
    '  /<C-r><C-w> 输入光标下单词',
    '',
    '  模式:',
    '  /^foo       行首匹配',
    '  /foo$       行尾匹配',
    '  /foo\\|bar   或 匹配',
    '  /\\<word\\>   整词匹配',
    '',
    '  高亮:',
    '  :noh        清除高亮（或 <leader>rh）',
  },
  ['?'] = {
    '  ? 反向搜索',
    '',
    '  ?foo        向前搜索 foo',
    '  n / N       下一个 / 上一个（方向互换）',
    '  （其余同 / 用法）',
  },
  [':'] = {
    '  : 命令模式 — 常用',
    '',
    '  :w          保存    :q 退出',
    '  :%s/a/b/g   全文件替换  (加 c 确认)',
    '  :e <file>   打开文件',
    '  :cd <dir>   切换目录',
    '  :grep ...   搜索进 quickfix',
    '  :cfdo %s/a/b/gc | update   批量替换',
    '  :!<cmd>     执行 shell',
    '  :set ...    设置选项',
  },
}

local win = nil

local function close_help()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
  win = nil
end

--- Show the help window for the current command type, top-right corner.
function M.maybe_show()
  close_help()
  local ctype = vim.fn.getcmdtype()
  local lines = HELP[ctype]
  if not lines then return end

  local width = 44
  local height = math.min(#lines + 2, vim.o.lines - 2)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  win = vim.api.nvim_open_win(buf, false, {
    relative = 'editor',
    width = width,
    height = height,
    row = 1,
    col = math.max(0, vim.o.columns - width - 1),
    style = 'minimal',
    border = 'rounded',
    zindex = 50,
  })
end

--- Close the help window (call on CmdlineLeave).
function M.maybe_close()
  close_help()
end

-- Wire up: CmdlineEnter shows, CmdlineLeave closes.
vim.api.nvim_create_autocmd('CmdlineEnter', {
  callback = M.maybe_show,
})
vim.api.nvim_create_autocmd('CmdlineLeave', {
  callback = M.maybe_close,
})

return M
