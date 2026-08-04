-- plugins/custom/utils/tree-root.lua — nvim-tree root helpers
-- Used by the <leader>mr mapping: point the tree root at the current
-- working directory (handy after the tree drifted elsewhere).

local M = {}

function M.tree_is_open()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == 'NvimTree' then
      return true
    end
  end
  return false
end

-- Set the nvim-tree root to the current working directory.
function M.root_to_cwd()
  if M.tree_is_open() then
    pcall(require('nvim-tree.api').tree.change_root, vim.fn.getcwd())
  end
end

return M
