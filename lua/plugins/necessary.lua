local M = {}

M.plugins_table = {}

---@class opts PluginsLoadOpts
---@field load_modules table<string, boolean>
---@field disbaled_plugins table<integer, string>
M.setup = function(opts)
    M.plugins_table = {}

    table.insert(M.plugins_table, {
        { import = "plugins.support" },
        { import = "plugins.colorscheme" },
        { import = "plugins.ui" },
        { import = "plugins.coding" }
    })

    if opts.load_modules ~= nil and next(opts.load_modules) ~= nil then
        for k, v in pairs(opts.load_modules) do
            if v then
                table.insert(M.plugins_table,
                    { import = "plugins." .. k })
            end
        end
    end

    if opts.disbaled_plugins ~= nil and next(opts.disbaled_plugins) ~= nil then
        for _, p in ipairs(opts.disbaled_plugins) do
            table.insert(M.plugins_table, { p, cond = false })
        end
    end

    return M.plugins_table
end

return M
