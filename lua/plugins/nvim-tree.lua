-- plugins/nvim-tree.lua — File explorer (nvim-tree, lazy spec)
-- VeryLazy (equivalent to old UIEnter; g:opened_with_dir is set at
-- VimEnter by options.lua before this reads it).
-- Persistent sidebar tree. <leader>e toggles it; <leader>er points root at cwd.
-- Default tree mappings are disabled; the in-tree keymap is defined in
-- on_attach below.

return {
  'nvim-tree/nvim-tree.lua',
  event = 'VeryLazy',
  config = function()
    -- Disable built-in netrw explorer (required before nvim-tree loads)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    local function on_attach(bufnr)
      local api = require('nvim-tree.api')
      -- Capture the tree's initial root on first attach (startup dir)
      require('plugins.custom.tree-root').capture_initial_root()
      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- Navigation (j/k move line-wise like arrow keys, crossing levels)
      vim.keymap.set('n', 'j', '<Down>', opts('Down'))
      vim.keymap.set('n', 'k', '<Up>', opts('Up'))
      vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Collapse directory'))
      -- l: expand directories, open files. The default open.edit would
      -- change_dir('..') on the path/.. node at the top (confusing — it
      -- silently moves the tree up); ignore l there instead. To point the
      -- root back at the cwd after any drift, use <leader>mr.
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
      -- Keep the native startup buffer (greeting) as the edit side: when
      -- nvim is opened on a directory the current buffer is a "directory
      -- buffer" (or unnamed empty), which nvim-tree would otherwise HIJACK
      -- (replace) — leaving only the tree. With hijacking off, the tree
      -- opens in its own left window and the greeting stays on the right.
      hijack_directories = { enable = false },
      hijack_unnamed_buffer_when_opening = false,
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

    -- Tree open/close is owned by wokamark (single owner of startup
    -- layout): nvim-tree never decides for itself. wokamark is eager, so
    -- it is loaded by the time this VeryLazy config runs.
    if require('wokamark').should_open_tree() then
      -- Wipe zombie tree buffers restored from a wokamark session:
      -- mksession stored the tree window's buffer (`edit NvimTree_1`),
      -- which comes back UNINITIALIZED (name NvimTree_1, ft not NvimTree)
      -- and would shadow the real tree. Delete them so NvimTreeOpen
      -- builds a fresh explorer.
      for _, b in ipairs(vim.api.nvim_list_bufs()) do
        local name = vim.api.nvim_buf_get_name(b)
        if vim.bo[b].filetype ~= 'NvimTree' and name:match('NvimTree_%d+$') and vim.api.nvim_buf_is_loaded(b) then
          pcall(vim.api.nvim_buf_delete, b, { force = true })
        end
      end
      vim.cmd('NvimTreeOpen')
      -- A tree restored from a wokamark session can come up empty (buffer
      -- restored, explorer not re-rendered) — refresh forces the render.
      vim.schedule(function()
        if vim.fn.exists(':NvimTreeRefresh') == 2 then
          pcall(vim.cmd, 'NvimTreeRefresh')
        end
      end)
      -- Focus the edit window (native buffer), not the tree.
      for _, w in ipairs(vim.api.nvim_list_wins()) do
        if vim.bo[vim.api.nvim_win_get_buf(w)].filetype ~= 'NvimTree' then
          vim.api.nvim_set_current_win(w)
          break
        end
      end
      -- Clean up dir-arg buffers (the `nvim <dir>` buffer named after the
      -- directory, and any restored copy from a wokamark session): it is
      -- an empty shell. Replace displayed ones with a clean No Name buffer,
      -- delete hidden ones. Session-restored FILE buffers are untouched
      -- (their name is a file, not a directory).
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
          -- Deferred delete: removing mid-config triggers lazy.nvim's
          -- buffer-event handler with a stale id; schedule settles the loop.
          local bb = b
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(bb) and vim.bo[bb].modified == false then
              pcall(vim.api.nvim_buf_delete, bb, { force = true })
            end
          end)
        end
      end
    end

    -- Edit-window q closes the CURRENT BUFFER, not the window: the window
    -- stays and shows the next buffer (or a No Name buffer), so the
    -- tree+edit split is preserved. Tree q (buffer-local, from on_attach)
    -- still closes the tree; help/terminal/quickfix keep the default q.
    vim.keymap.set('n', 'q', function()
      local buf = vim.api.nvim_get_current_buf()
      if vim.bo[buf].buftype ~= '' then return end -- default q elsewhere
      vim.cmd('bdelete ' .. buf)
    end, { desc = 'Close current buffer (window stays)' })
  end,
}
