-- plugins/comment.lua — Comment toggling (lazy spec)
-- Key: g// = toggle line comment, g/ (operator) + motion = comment motion
-- Loaded on first BufReadPost/BufNewFile (equivalent to old BufReadPost once).

return {
  'numToStr/Comment.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    require('Comment').setup({
      toggler = {
        line = 'g//',
        block = 'gb/',
      },
      opleader = {
        line = 'g/',
        block = 'gb/',
      },
    })
  end,
}
