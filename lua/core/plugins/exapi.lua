local M = {}

local bd = require("bufdelete")
M.bufdel = {
    ---@param force boolean
    del_current = function(force)
        force = false or force

        local bufnr = vim.api.nvim_get_current_buf()

        bd.bufdelete(bufnr, force)
    end,

    del_others = function(force)
        force = false or force

        local exbufnr = vim.api.nvim_get_current_buf()
        local delbuf = vim.tbl_filter(function(bufnr)
            return bufnr ~= exbufnr
        end, vim.api.nvim_list_bufs())

        bd.bufdelete(delbuf, force)
    end
}

return M
