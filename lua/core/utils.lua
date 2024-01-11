local M = {}

-- This file is largely based on LazyVim util module
-- https://github.com/LazyVim/LazyVim/tree/main/lua/lazyvim/util

M.icons = {
    misc = {
        -- arrows
        dots              = "󰇘",
        uparrow_bold      = "",
        downarrow_bold    = "",
        leftarrow_bold    = "",
        rightarrow_bold   = "",
        uparrow           = "",
        downarrow         = "",
        leftarrow         = "",
        rightarrow        = "",
        uparrow_double    = "",
        downarrow_double  = "",
        leftarrow_double  = "",
        rightarrow_double = "",

        plus              = "",
        minus             = "",
    },

    git_status = {
        -- Change type
        added     = "✚",
        modified  = "",
        deleted   = "✖",
        renamed   = "󰁕",

        -- Status type
        untracked = "",
        ignored   = "",
        unstaged  = "󰄱",
        staged    = "",
        conflict  = "",
    },

    diagnostic = {
        error = " ",
        warn  = " ",
        info  = " ",
        hint  = "󰌵",
    },

    other = {
        gear  = "",
        flash = "",
        check = "",
        close = "",
        code  = ""
    },
}

M.set_colorscheme = function(colorscheme)
    vim.cmd.colorscheme { colorscheme }
end

M.run_update = function()

end

M.fold_text = function()
    local ok = pcall(vim.treesitter.get_parser, vim.api.nvim_get_current_buf())
    local ret = ok and vim.treesitter.foldtext and vim.treesitter.foldtext()
    if not ret or type(ret) == "string" then
        ret = { { vim.api.nvim_buf_get_lines(0, vim.v.lnum - 1, vim.v.lnum, false)[1], {} } }
    end
    table.insert(ret, { " " .. M.icons.misc.dots })

    if not vim.treesitter.foldtext then
        return table.concat(
            vim.tbl_map(function(line)
                return line[1]
            end, ret),
            " "
        )
    end
    return ret
end

M.safe_keymap_set = function(mode, lhs, rhs, opts)
    local keys = require("lazy.core.handler").handlers.keys
    ---@cast keys LazyKeysHandler
    local modes = type(mode) == "string" and { mode } or mode

    ---@param m string
    modes = vim.tbl_filter(function(m)
        return not (keys.have and keys:have(lhs, m))
    end, modes)

    -- do not create the keymap if a lazy keys handler exists
    if #modes > 0 then
        opts = opts or {}
        opts.silent = opts.silent ~= false
        if opts.remap and not vim.g.vscode then
            ---@diagnostic disable-next-line: no-unknown
            opts.remap = nil
        end
        vim.keymap.set(modes, lhs, rhs, opts)
    end
end

M.plugin_exits = function(plugin)
    return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

---@param plugin string
function M.has(plugin)
    return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

---@param fn fun()
function M.on_very_lazy(fn)
    vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
            fn()
        end,
    })
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
    local Config = require("lazy.core.config")
    if Config.plugins[name] and Config.plugins[name]._.loaded then
        fn(name)
    else
        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyLoad",
            callback = function(event)
                if event.data == name then
                    fn(name)
                    return true
                end
            end,
        })
    end
end

-- delay notifications till vim.notify was replaced or after 500ms
function M.lazy_notify()
    local notifs = {}
    local function temp(...)
        table.insert(notifs, vim.F.pack_len(...))
    end

    local orig = vim.notify
    vim.notify = temp

    local timer = vim.loop.new_timer()
    local check = assert(vim.loop.new_check())

    local replay = function()
        timer:stop()
        check:stop()
        if vim.notify == temp then
            vim.notify = orig -- put back the original notify if needed
        end
        vim.schedule(function()
            ---@diagnostic disable-next-line: no-unknown
            for _, notif in ipairs(notifs) do
                vim.notify(vim.F.unpack_len(notif))
            end
        end)
    end

    -- wait till vim.notify has been replaced
    check:start(function()
        if vim.notify ~= temp then
            replay()
        end
    end)
    -- or if it took more than 500ms, then something went wrong
    timer:start(500, 0, replay)
end

M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }
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
            event_handler.triffer({
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

return M
