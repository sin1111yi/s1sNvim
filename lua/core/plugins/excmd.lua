local M = {}

local plugins_excmd_table = {
    ["ProjectBrowser"] = {
        func = function()
            local project_histroy = vim.fn.stdpath("data") .. "/project_nvim/project_history"
            vim.cmd("e " .. project_histroy)
        end,
        opts = {
            desc = "Edit project histroy generated by project.nvim"
        }
    }
}

---@param cmd string
local set_plugins_excmds = function(cmd)
    for c, tb in pairs(plugins_excmd_table) do
        if c == cmd then
            vim.api.nvim_create_user_command(cmd, tb.func, tb.opts)
        end
    end
end

M.setup = function()
    set_plugins_excmds("ProjectBrowser")
end

return M
