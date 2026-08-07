-- plugins/bufferline.lua — Buffer tab bar (lazy spec)
-- VeryLazy (equivalent to old UIEnter). Deps: nvim-web-devicons for
-- get_element_icon. Colorscheme integration handled automatically by
-- catppuccin.

return {
  'akinsho/bufferline.nvim',
  event = 'VeryLazy',
  commit = '655133c3b4c3e5e05ec549b9f8cc2894ac6f51b3', -- migration pin (nvim-pack-lock.json rev)
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('bufferline').setup({
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
              local git = require('plugins.custom.git-head').get()
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
  end,
}
