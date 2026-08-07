-- plugins/comment.lua — Comment toggling (lazy spec)
-- Key: g// = toggle line comment, g/ (operator) + motion = comment motion
-- Loaded on first BufReadPost/BufNewFile (equivalent to old BufReadPost once).

return {
  'numToStr/Comment.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  commit = 'e30b7f2008e52442154b66f7c519bfd2f1e32acb', -- migration pin
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
