local M = {}

M.plugins_table = {}

---@param opts PluginsLoadOpts
M.setup = function(opts)
    if opts.load_modules ~= nil and next(opts.load_modules) ~= nil then
        ---@param module string
        ---@return boolean
        local function mod_exist(module)
            local mod_path = vim.fn.stdpath("config") .. "/lua/plugins/"
            module = string.gsub(module, "%.", "/")
            return vim.loop.fs_stat(mod_path .. module) ~= nil
        end

        for mod, load in pairs(opts.load_modules) do
            local exist = mod_exist(mod)

            if load and exist then
                table.insert(M.plugins_table,
                    { import = "plugins." .. mod })
            elseif not exist then
                vim.notify("Module \"" .. mod .. "\" is not existed!")
            end
        end
    end

    if opts.extra_modules ~= nil and next(opts.extra_modules) ~= nil then
        ---@param module string
        ---@return boolean
        local function extra_module_exist(module)
            local mod_path = vim.fn.stdpath("config") .. "/lua/plugins/extra/"
            return vim.loop.fs_stat(mod_path .. module .. ".lua") ~= nil
        end

        for exmod, load in pairs(opts.extra_modules) do
            local exist = extra_module_exist(exmod)
            if load and exist then
                table.insert(M.plugins_table, require("plugins.extra." .. exmod))
            elseif not exist then
                vim.notify("Extra module \"" .. exmod .. "\" is not existed!")
            end
        end
    end

    if opts.disbaled_plugins ~= nil and next(opts.disbaled_plugins) ~= nil then
        for _, p in ipairs(opts.disbaled_plugins) do
            table.insert(M.plugins_table, { p, enabled = false })
        end
    end

    return M.plugins_table
end

return M
