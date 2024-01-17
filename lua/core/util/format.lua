local util = require("core.util")

---@class core.util.format
---@overload fun(opts?: {force?:boolean})
local M = setmetatable({}, {
    __call = function(m, ...)
        return m.format(...)
    end,
})

---@class LazyFormatter
---@field name string
---@field primary? boolean
---@field format fun(bufnr:number)
---@field sources fun(bufnr:number):string[]
---@field priority number

M.formatters = {} ---@type LazyFormatter[]

---@param formatter LazyFormatter
function M.register(formatter)
    M.formatters[#M.formatters + 1] = formatter
    table.sort(M.formatters, function(a, b)
        return a.priority > b.priority
    end)
end

---@param buf? number
---@return (LazyFormatter|{active:boolean,resolved:string[]})[]
function M.resolve(buf)
    buf = buf or vim.api.nvim_get_current_buf()
    local have_primary = false
    ---@param formatter LazyFormatter
    return vim.tbl_map(function(formatter)
        local sources = formatter.sources(buf)
        local active = #sources > 0 and (not formatter.primary or not have_primary)
        have_primary = have_primary or (active and formatter.primary) or false
        return setmetatable({
            active = active,
            resolved = sources,
        }, { __index = formatter })
    end, M.formatters)
end

---@param buf? number
function M.enabled(buf)
    buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
    local gaf = vim.g.autoformat
    local baf = vim.b[buf].autoformat

    -- If the buffer has a local value, use that
    if baf ~= nil then
        return baf
    end

    -- Otherwise use the global value if set, or true by default
    return gaf == nil or gaf
end

---@param buf? boolean
function M.toggle(buf)
    if buf then
        vim.b.autoformat = not M.enabled()
    else
        vim.g.autoformat = not M.enabled()
        vim.b.autoformat = nil
    end
end

---@param opts? {force?:boolean, buf?:number}
function M.format(opts)
    opts = opts or {}
    local buf = opts.buf or vim.api.nvim_get_current_buf()
    if not ((opts and opts.force) or M.enabled(buf)) then
        return
    end

    local done = false
    for _, formatter in ipairs(M.resolve(buf)) do
        if formatter.active then
            done = true
            util.try(function()
                return formatter.format(buf)
            end, { msg = "Formatter `" .. formatter.name .. "` failed" })
        end
    end

    if not done and opts and opts.force then
        util.warn("No formatter available")
    end
end

function M.setup()
    -- Autoformat autocmd
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("Formatter", {}),
        callback = function(event)
            M.format({ buf = event.buf })
        end,
    })

    -- Manual format
    vim.api.nvim_create_user_command("FormatterRun", function()
        M.format({ force = true })
    end, { desc = "Format selection or buffer" })

    -- Format info
    vim.api.nvim_create_user_command("FormatterInfo", function()
        M.info()
    end, { desc = "Show info about the formatters for the current buffer" })
end

return M
