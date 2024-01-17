local M = {}

local bd = require("bufdelete")
local wp = require("window-picker")

M.buf_del = {
    ---@param force boolean
    del_current = function(force)
        force = false or force

        local bufnr = vim.api.nvim_get_current_buf()

        bd.bufdelete(bufnr, force)
    end,

    ---@param force boolean
    del_others = function(force)
        force = false or force

        local exbufnr = vim.api.nvim_get_current_buf()

        ---@type table<integer, bufnr>
        local buffers = vim.tbl_filter(function(bufnr)
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            -- if the bufnr is not current, either filesystem
            return bufnr ~= exbufnr and string.find(bufname, "filesystem") == nil
        end, vim.api.nvim_list_bufs())

        bd.bufwipeout(buffers, force)
    end,

    -- to use this function, bufferline must sort buffers in order of bufer
    ---@param target string
    ---@param force boolean
    del_matches = function(target, force)
        force = false or force
        local exbufnr = vim.api.nvim_get_current_buf()

        local buffers = vim.tbl_filter(function(bufnr)
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            if string.find(bufname, "filesystem") == nil then
                local _match_opts = function(opts)
                    local _opts = {
                        ["left"] = bufnr < exbufnr,
                        ["right"] = bufnr > exbufnr,
                        ["all"] = true,
                    }
                    return _opts[opts]
                end
                return _match_opts(target)
            end
        end, vim.api.nvim_list_bufs())

        bd.bufwipeout(buffers, force)
    end
}

return M
