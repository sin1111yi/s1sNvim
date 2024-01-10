local M = {}

M.setup = function(opts)
    local plugins_table = {}

    table.insert(plugins_table, {
        { import = "plugins.support" },
        { import = "plugins.colorscheme" },
        { import = "plugins.ui" }
    })

    if opts.load_plugins.extra == true then
        table.insert(plugins_table, { import = "plugins.extra" })
    end

    if opts.load_plugins.custom == true then
        table.insert(plugins_table, { import = "plugins.custom" })
    end

    return plugins_table
end

return M
