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

        local buffers = vim.tbl_filter(function(bufnr)
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            return bufnr ~= exbufnr and string.find(bufname, "filesystem") == nil
        end, vim.api.nvim_list_bufs())

        bd.bufwipeout(buffers, force)

    end
}

return M
