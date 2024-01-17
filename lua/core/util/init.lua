-- this util class highly based on https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util

---@class core.util: LazyUtilCore
---@field ui core.util.ui
---@field lsp core.util.lsp
---@field plugin core.util.plugin
---@field format core.util.format

local M = {}

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

        oct_dot           = "",
        oct_dot_fill      = "",
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
        gear        = "",
        flash       = "",
        check       = "",
        close       = "",
        code        = "",
        star_3      = "󰫥",
        star_4      = "󰫣",
        star_3_fill = "󰫤",
        star_4_fill = "󰫢",
    },
}

---@param plugin string
M.has = function(plugin)
    return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

---@param fn fun()
M.on_very_lazy = function(fn)
    vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
            fn()
        end,
    })
end

-- delay notifications till vim.notify was replaced or after 500ms
M.lazy_notify = function()
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

---@param name string
---@param fn fun(name:string)
M.on_load = function(name, fn)
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

-- Wrapper around vim.keymap.set that will
-- not create a keymap if a lazy key handler exists.
-- It will also set `silent` to true by default.
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

return M