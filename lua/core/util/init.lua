-- this util class highly based on https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util

local LazyUtil = require("lazy.core.util")

---@class core.util: LazyUtilCore
---@field ui core.util.ui
---@field lsp core.util.lsp
---@field root core.util.root
---@field inject core.util.inject
---@field plugin core.util.plugin
---@field format core.util.format
---@field toggle core.util.toggle
local M = {}

setmetatable(M, {
    __index = function(t, k)
        if LazyUtil[k] then
            return LazyUtil[k]
        end
        ---@diagnostic disable-next-line: no-unknown
        t[k] = require("core.util." .. k)
        return t[k]
    end
})

---@return boolean
---@param os "Windows" | "Linux"
M.os_is = function(os)
    return vim.loop.os_uname().sysname:find(os) ~= nil
end

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

---@param name string
function M.opts(name)
    local plugin = require("lazy.core.config").plugins[name]
    if not plugin then
        return {}
    end
    local Plugin = require("lazy.core.plugin")
    return Plugin.values(plugin, "opts", false)
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

M.better_nvim_keymap_set = function(mode, lhs, rhs, opts)
    local _opts = { remap = true, silent = true }
    if type(opts) == "string" then
        _opts.desc = opts
    else
        _opts = vim.tbl_deep_extend("force", _opts, opts)
    end
    vim.keymap.set(mode, lhs, rhs, _opts)
end


return M
