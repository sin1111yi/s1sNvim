local Util = require("core.util")

---@class core.util.plugin
local M = {}

M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }
-- Properly load file based plugins without blocking the UI
M.lazy_file = function()
    local use_lazy_file = true and vim.fn.argc(-1) > 0
    -- Add support for the LazyFile event
    local event_handler = require("lazy.core.handler.event")

    if use_lazy_file then
        event_handler.mappings.LazyFile = { id = "LazyFile", event = "User", pattern = "LazyFile" }
        event_handler.mappings["User LazyFile"] = event_handler.mappings.LazyFile
    else
        -- Don't delay execution of LazyFile events, but let lazy know about the mapping
        event_handler.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
        event_handler.mappings["User LazyFile"] = event_handler.mappings.LazyFile
        return
    end

    local events = {} ---@type {event: string, buf: number, data?: any}[]

    local load = function()
        if #events == 0 then
            return
        end
        vim.api.nvim_del_augroup_by_name("lazy_file")

        ---@type table<string,string[]>
        local skips = {}
        for _, event in ipairs(events) do
            skips[event.event] = skips[event.event] or event_handler.get_augroups(event.event)
        end

        vim.api.nvim_exec_autocmds("User", { pattern = "LazyFile", modeline = false })
        for _, event in ipairs(events) do
            event_handler.trigger({
                event = event.event,
                exclude = skips[event.event],
                data = event.data,
                buf = event.buf,
            })
            if vim.bo[event.buf].filetype then
                event_handler.trigger({
                    event = "FileType",
                    buf = event.buf
                })
            end
        end
        vim.api.nvim_exec_autocmds("CursorMoved", { modeline = false })
        events = {}
    end
    -- schedule wrap so that nested autocmds are executed
    -- and the UI can continue rendering without blocking
    load = vim.schedule_wrap(load)

    vim.api.nvim_create_autocmd(M.lazy_file_events, {
        group = vim.api.nvim_create_augroup("lazy_file", { clear = true }),
        callback = function(event)
            table.insert(events, event)
            load()
        end,
    })
end

function M.setup()
    M.lazy_file()
end

return M
