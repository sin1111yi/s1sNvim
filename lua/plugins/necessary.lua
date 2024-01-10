local M = {}

M.plugins_table = {}

---@param opts table
M.setup = function(opts)
    M.plugins_table = {}

    table.insert(M.plugins_table, {
        { import = "plugins.support" },
        { import = "plugins.colorscheme" },
        { import = "plugins.ui" }
    })

    if opts.load_plugins.extra == true then
        table.insert(M.plugins_table, { import = "plugins.extra" })
    end

    if opts.load_plugins.custom == true then
        table.insert(M.plugins_table, { import = "plugins.custom" })
    end

    return M.plugins_table
end

return M
