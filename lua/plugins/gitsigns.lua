-- plugins/gitsigns.lua — Git diff signs in the gutter (lazy spec)
-- Loaded on first BufReadPost/BufNewFile (equivalent to old once).

return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    require('gitsigns').setup({})

    -- Refresh the bufferline offset git info (git-head cache) for a buffer and
    -- force a tabline redraw so the branch/status appears as soon as it's ready.
    local function refresh(bufnr)
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(bufnr) then return end
        require('plugins.custom.git-head').update(
          vim.b[bufnr].gitsigns_status_dict,
          vim.b[bufnr].gitsigns_ahead_behind
        )
        vim.cmd('redrawtabline')
      end)
    end

    -- Ahead/behind support: gitsigns has no native API for this, so fetch
    -- HEAD vs @{upstream} asynchronously. Result stored in b:gitsigns_ahead_behind.
    local function update_ahead_behind(bufnr)
      if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then return end
      vim.system({ 'git', 'rev-list', '--left-right', '--count', 'HEAD...@{upstream}' }, { text = true }, function(obj)
        -- on_exit runs in fast event context: defer API access to the main loop
        vim.schedule(function()
          if not vim.api.nvim_buf_is_valid(bufnr) then return end
          if obj.code == 0 then
            local ahead, behind = (obj.stdout or ''):match('(%d+)%s+(%d+)')
            vim.b[bufnr].gitsigns_ahead_behind =
              (ahead and behind) and { ahead = tonumber(ahead), behind = tonumber(behind) } or nil
          else
            -- No upstream configured (or not a git repo): no ahead/behind info
            vim.b[bufnr].gitsigns_ahead_behind = nil
          end
          refresh(bufnr)
        end)
      end)
    end

    vim.api.nvim_create_autocmd('User', {
      pattern = 'GitSignsUpdate',
      callback = function(args)
        local bufnr = args.data and args.data.buffer
        if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then return end
        update_ahead_behind(bufnr)
        refresh(bufnr)
      end,
    })

    -- Save event: refresh the bufferline git info immediately after writing.
    -- gitsigns also refreshes on save (GitSignsUpdate), but this guarantees
    -- the offset text updates right away even if that chain is delayed.
    vim.api.nvim_create_autocmd('BufWritePost', {
      pattern = '*',
      callback = function(args)
        vim.schedule(function()
          if not vim.api.nvim_buf_is_valid(args.buf) then return end
          require('plugins.custom.git-head').update(
            vim.b[args.buf].gitsigns_status_dict,
            vim.b[args.buf].gitsigns_ahead_behind
          )
          vim.cmd('redrawtabline')
        end)
      end,
    })
  end,
}
