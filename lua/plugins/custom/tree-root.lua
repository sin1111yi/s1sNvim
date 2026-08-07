-- plugins/custom/tree-root.lua — nvim-tree root helpers
-- <leader>er points the tree root back at the tree's INITIAL root (the
-- startup directory), not getcwd() — after the tree drifted (e.g. via
-- change_dir or the old path-node l behaviour), this is what users mean
-- by "go back to my project".

local M = {}

local initial_root = nil

function M.tree_is_open()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == 'NvimTree' then
      return true
    end
  end
  return false
end

-- Capture the tree's initial root on first use (called from nvim-tree's
-- on_attach): prefer the startup directory argument, else the boot cwd.
function M.capture_initial_root()
  if initial_root then return initial_root end
  local argv0 = vim.fn.argv(0)
  if argv0 ~= '' and vim.fn.isdirectory(argv0) == 1 then
    initial_root = vim.fn.fnamemodify(vim.fn.expand(argv0), ':p')
  else
    initial_root = vim.fn.getcwd()
  end
  return initial_root
end

-- Point the tree root back at the initial (startup) directory.
function M.root_to_initial()
  local root = M.capture_initial_root()
  if M.tree_is_open() and root then
    pcall(require('nvim-tree.api').tree.change_root, root)
  end
end

-- Prompt for a directory, cd to it and open the tree there.
function M.open_dir()
  local path = vim.fn.input({ prompt = 'Open directory: ', default = '~/', completion = 'dir' })
  if path == '' then return end
  path = vim.fn.expand(path)
  if vim.fn.isdirectory(path) ~= 1 then
    vim.notify('Not a directory: ' .. path, vim.log.levels.WARN)
    return
  end
  vim.cmd('cd ' .. vim.fn.fnameescape(path))
  vim.cmd('NvimTreeOpen')
  vim.cmd('wincmd p')
end

return M
