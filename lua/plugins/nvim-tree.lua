-- plugins/nvim-tree.lua — File explorer (nvim-tree, lazy spec)

return {
  'nvim-tree/nvim-tree.lua',
  event = 'VeryLazy',
  config = function()
    -- Disable built-in netrw explorer
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    local function on_attach(bufnr)
      local api = require('nvim-tree.api')
      -- Record the tree's initial root (used by <leader>er)
      require('plugins.custom.tree-root').capture_initial_root()
      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- Navigation
      vim.keymap.set('n', 'j', '<Down>', opts('Down'))
      vim.keymap.set('n', 'k', '<Up>', opts('Up'))
      vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Collapse directory'))
      -- l: expand directories, open files; ignore the path/.. node (the
      -- default would change the tree root there)
      vim.keymap.set('n', 'l', function()
        local node = api.tree.get_node_under_cursor()
        if not node or node.name == '..' then return end
        if node.type == 'directory' then
          pcall(function() node:expand_or_collapse(false) end)
        else
          api.node.open.edit(node)
        end
      end, opts('Expand / open'))
      vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))

      -- Fold / unfold
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
      -- Don't hijack the startup buffer: the tree opens in its own left
      -- window and the native edit buffer stays on the right.
      hijack_directories = { enable = false },
      hijack_unnamed_buffer_when_opening = false,
      renderer = {
        group_empty = true,
        highlight_hidden = 'all',
      },
      filters = {
        dotfiles = false, -- show hidden files
      },
      on_attach = on_attach,
      experimental = {
        session_restore_nvim = true,
      },
    })

    -- Grey out hidden files (dotfiles)
    vim.api.nvim_set_hl(0, 'NvimTreeHiddenFileHL', { link = 'Comment' })
    vim.api.nvim_set_hl(0, 'NvimTreeHiddenFolderHL', { link = 'Comment' })

    -- Tree open/close is decided by wokamark (should_open_tree); this
    -- config only executes the open when asked. Also open when a tree
    -- buffer was restored by a wokamark session but has no window yet
    -- (bare `nvim` startup with a restored workspace).
    local has_tree_buf = vim.fn.bufexists('NvimTree_1') == 1
    if require('wokamark').should_open_tree() or has_tree_buf then
      -- Remove uninitialized tree buffers restored from a session
      -- (name NvimTree_%d but ft not NvimTree) so the real tree builds
      -- fresh instead of being shadowed.
      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        local name = vim.api.nvim_buf_get_name(b)
        if vim.bo[b].filetype ~= 'NvimTree' and name:match('NvimTree_%d+$') and vim.api.nvim_buf_is_loaded(b) then
          pcall(vim.api.nvim_buf_delete, b, { force = true })
        end
      end
      vim.cmd('NvimTreeOpen')
      -- Restore cwd and tree root to the startup directory (a session
      -- restore may have cd'd elsewhere).
      local root = vim.g.startup_dir or vim.fn.getcwd()
      if vim.g.startup_dir then
        pcall(vim.cmd, 'cd ' .. vim.fn.fnameescape(vim.g.startup_dir))
      end
      vim.schedule(function()
        local ok, api = pcall(require, 'nvim-tree.api')
        if ok then
          pcall(api.tree.change_root, root)
        end
      end)
      -- Re-render a session-restored tree that may be empty
      vim.schedule(function()
        if vim.fn.exists(':NvimTreeRefresh') == 2 then
          pcall(vim.cmd, 'NvimTreeRefresh')
        end
      end)
      -- Focus the edit window, not the tree
      for _, w in ipairs(vim.api.nvim_list_wins()) do
        if vim.bo[vim.api.nvim_win_get_buf(w)].filetype ~= 'NvimTree' then
          vim.api.nvim_set_current_win(w)
          break
        end
      end
      -- Replace dir-arg buffers (empty shells named after a directory)
      -- with No Name; delete hidden ones. File buffers are untouched.
      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        local n = vim.api.nvim_buf_get_name(b)
        if n ~= '' and vim.fn.isdirectory(n) == 1 and vim.bo[b].modified == false then
          local shown = false
          for _, w in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(w) == b then
              shown = true
              vim.api.nvim_set_current_win(w)
              vim.cmd('enew')
              break
            end
          end
          local bb = b
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(bb) and vim.bo[bb].modified == false then
              pcall(vim.api.nvim_buf_delete, bb, { force = true })
            end
          end)
        end
      end
    end

    -- q in edit windows closes the BUFFER (window stays, shows next
    -- buffer / No Name). Tree q closes the tree; help/terminal keep q.
    vim.keymap.set('n', 'q', function()
      local buf = vim.api.nvim_get_current_buf()
      if vim.bo[buf].buftype ~= '' then return end
      vim.cmd('bdelete ' .. buf)
    end, { desc = 'Close current buffer (window stays)' })
  end,
}
