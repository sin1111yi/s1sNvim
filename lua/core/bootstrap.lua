local M = {}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

local Util = require("core.util")

---@param name "autocmds" | "options" | "keymaps"
M.load = function(name)
    local function _load(mod)
        if require("lazy.core.cache").find(mod)[1] then
            Util.try(function()
                require(mod)
            end, { msg = "Failed loading " .. mod })
        end
    end

    _load("core." .. name)
    if vim.bo.filetype == "lazy" then
        -- HACK: LazyVim may have overwritten options of the Lazy ui, so reset this here
        vim.cmd([[do VimResized]])
    end
    local pattern = "s1sVim" .. name:sub(1, 1):upper() .. name:sub(2)
    vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
end

---@class PluginsLoadOpts
local pluginsConf = {
    ---@type table<string, boolean>
    load_modules = {
        ["support"] = true,
        ["colorscheme"] = true,
        ["ui"] = true,
        ["coding"] = true,
        ["coding.support"] = true,

        ["extra"] = true,
        ["custom"] = false,
    },

    ---@type string[]
    disbaled_plugins = {
        -- for example, uncomment this line to let lazy ignore neodev
        -- "folke/neodev.nvim",
    },
}

local opts = {
    defaults = {
        lazy = true,
        version = "*" -- always use the latest git commit
    },

    checker = { enabled = true }, -- automatically check for plugin updates

    performance = {
        disbaled_plugins = {
            "gzip",
            "matchit",
            "matchparen",
            "netrwPlugin",
            "tarPlugin",
            "tohtml",
            "tutor",
            "zipPlugin",
        }
    }
}

local create_usr_cmds = function()
    vim.api.nvim_create_user_command("LazyHealth", function()
        vim.cmd("Lazy! load all")
        vim.cmd("checkhealth")
    end, { desc = "Load all plugins and run :checkhealth" })

    vim.api.nvim_create_user_command("UpdateAll", function()
        vim.cmd("TSUpdate all")
        vim.cmd("MasonUpdate")
    end, { bang = true, nargs = 0, desc = "Update all" })
end

---@param buf? number
---@return string[]?
function M.get_kind_filter(buf)
    buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
    local ft = vim.bo[buf].filetype
    if M.kind_filter == false then
        return
    end
    if M.kind_filter[ft] == false then
        return
    end
    ---@diagnostic disable-next-line: return-type-mismatch
    return type(M.kind_filter) == "table" and type(M.kind_filter.default) == "table" and M.kind_filter.default or nil
end

M.setup = function()
    M.load("options")
    Util.lazy_notify()
    Util.format.setup()
    Util.plugin.setup()

    require("lazy").setup(require("plugins.necessary").setup(pluginsConf), opts)

    M.load("keymaps")
    M.load("autocmds")

    create_usr_cmds()

    Util.ui.set_colorscheme("catppuccin")
end

return M
