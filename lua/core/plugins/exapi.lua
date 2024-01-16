local M = {}

local bd = require("bufdelete")
M.bufdel = {
    ---@param bufnr integer
    ---@param force boolean
    del_current = function(bufnr, force)
        bd.bufdelete(bufnr, force)
    end,
}

return M
