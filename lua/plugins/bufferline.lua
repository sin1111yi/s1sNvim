-- plugins/bufferline.lua — Buffer tab bar
-- Loaded on UIEnter (once).
-- Colorscheme integration handled automatically by catppuccin.

local U = require('config.util')
return U.try_load('bufferline', function(bl)
  bl.setup({
    options = {
      mode = 'buffers',
      show_close_icon = false,
      show_buffer_icons = true,
      get_element_icon = function(opts)
        return require('nvim-web-devicons').get_icon(
          opts.path, nil, { default = false }
        )
      end,
      separator_style = 'thin',
      offsets = {
        -- Space above nvim-tree shows the current directory name; buffers
        -- start after it. highlight = NvimTreeNormal makes the segment blend
        -- into the tree background (NvimTreeNormalFloat differs).
        {
          filetype = 'NvimTree',
          text = function()
            -- Git branch + status icon (✓ clean / ● dirty), falls back to
            -- the current directory name outside a git repo.
            local git = require('plugins.custom.utils.git-head').get()
            if git then return git end
            local ok, cwd = pcall(vim.fn.getcwd)
            if not ok or cwd == nil or cwd == '' then return 'Explorer' end
            local name = vim.fn.fnamemodify(cwd, ':t')
            return name ~= '' and name or 'Explorer'
          end,
          highlight = 'NvimTreeNormal',
          separator = true,
        },
      },
    },
  })
end)
