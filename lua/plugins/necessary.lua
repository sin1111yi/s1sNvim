local M = {}

M.plugins_table = {}

---@param opts PluginsLoadOpts
M.setup = function(opts)
    local mod_path = vim.fn.stdpath("config") .. "/lua/plugins/"

    if opts.load_modules ~= nil and next(opts.load_modules) ~= nil then
        for k, v in pairs(opts.load_modules) do
            local mod_exist = vim.loop.fs_stat(mod_path .. k) ~= nil

            if v and mod_exist then
                table.insert(M.plugins_table,
                    { import = "plugins." .. k })
            elseif not mod_exist then
                vim.notify("Module \"" .. k .. "\" is not existed!\n")
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
