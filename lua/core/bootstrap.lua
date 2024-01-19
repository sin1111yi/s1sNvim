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
local load = function(name)
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

        ["extra"] = true,
        ["custom"] = false,
    },

    ---@type string[]
    disbaled_plugins = {
        -- for example, uncomment this line to let lazy ignore neodev
        -- "folke/neodev.nvim",
    }
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

M.setup = function()
    load("options")
    Util.lazy_notify()
    Util.plugin.setup()

    require("lazy").setup(require("plugins.necessary").setup(pluginsConf), opts)

    load("keymaps")
    load("autocmds")

    Util.ui.set_colorscheme("catppuccin")
end

return M
