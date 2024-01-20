local M = {}

M.plugins_table = {}

---@param opts PluginsLoadOpts
M.setup = function(opts)
    if opts.load_modules ~= nil and next(opts.load_modules) ~= nil then
        for k, v in pairs(opts.load_modules) do
            
            ---@param module string
            ---@return boolean
            local function mod_exist(module)
                local mod_path = vim.fn.stdpath("config") .. "/lua/plugins/"
                module = string.gsub(module, "%.", "/")
                return vim.loop.fs_stat(mod_path .. module) ~= nil
            end

            if not mod_exist(k) then
                vim.notify("Module \"" .. k .. "\" is not existed!\n")
            end

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
