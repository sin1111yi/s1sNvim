-- plugins/comment.lua — Comment toggling
-- Key: g// = toggle line comment, g/ (operator) + motion = comment motion
-- Loaded on first BufReadPost (once)

local U = require('config.util')
return U.try_load('Comment', function(c)
  c.setup({
    toggler = {
      line = 'g//',
      block = 'gb/',
    },
    opleader = {
      line = 'g/',
      block = 'gb/',
    },
  })
end)
