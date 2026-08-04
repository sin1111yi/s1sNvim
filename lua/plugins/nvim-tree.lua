-- plugins/nvim-tree.lua — File explorer (nvim-tree)
-- Loaded on UIEnter (once).
-- Persistent sidebar tree. <leader>e toggles it; <leader>er points root at cwd.
-- Default tree mappings are disabled; the in-tree keymap is defined in
-- on_attach below.

local U = require('config.util')
return U.try_load('nvim-tree', function()
  -- Disable built-in netrw explorer (required before nvim-tree loads)
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  local function on_attach(bufnr)
    local api = require('nvim-tree.api')
    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- Navigation (j/k move line-wise like arrow keys, crossing levels)
    vim.keymap.set('n', 'j', '<Down>', opts('Down'))
    vim.keymap.set('n', 'k', '<Up>', opts('Up'))
    vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Collapse directory'))
    vim.keymap.set('n', 'l', api.node.open.edit, opts('Expand / open'))
    vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))

    -- Fold / unfold (collapse / expand current directory)
    vim.keymap.set('n', '>', api.node.navigate.parent_close, opts('Collapse directory'))
    vim.keymap.set('n', '<', api.node.open.edit, opts('Expand directory'))

    -- File operations
    vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
    vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
    vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
    vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
    vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
    vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy name'))

    -- Tree root / close / help
    vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
    vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
    vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))
  end

  require('nvim-tree').setup({
    view = { width = 30 },
    renderer = {
      group_empty = true,
      highlight_hidden = 'all',  -- enable hidden-file highlighting (icon + name)
    },
    filters = {
      dotfiles = false,  -- show hidden files
    },
    on_attach = on_attach,
    experimental = {
      -- Restore nvim-tree buffers when restoring vim sessions
      session_restore_nvim = true,
    },
  })

  -- Grey out hidden files (dotfiles) by linking their highlight groups to Comment
  vim.api.nvim_set_hl(0, 'NvimTreeHiddenFileHL', { link = 'Comment' })
  vim.api.nvim_set_hl(0, 'NvimTreeHiddenFolderHL', { link = 'Comment' })

  -- Auto-open on startup (this file loads at UIEnter, UI is already ready),
  -- then return focus to the edit window
  vim.cmd('NvimTreeOpen')
  vim.cmd('wincmd p')
end)
