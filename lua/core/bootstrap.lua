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
    local pattern = "LazyVim" .. name:sub(1, 1):upper() .. name:sub(2)
    vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
end

local plugins = require("plugins.necessary").setup({
    load_modules = {
        ["extra"] = true,
        ["custom"] = false,
    },

    -- plugins is this table will be ignored
    disbaled_plugins = {}
})



local init = function()
    load("options")
    Util.lazy_notify()
    Util.plugin.setup()

    require("lazy").setup(plugins, {
        defaults = {
            lazy = true,
            version = "*" -- always use the latest git commit
        },

        checker = { enabled = true }, -- automatically check for plugin updates

        performance = {
            -- disable some rtp plugins like LazyVim
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
    })

    load("keymaps")
    load("autocmds")

    Util.ui.set_colorscheme("catppuccin")
end

init()
