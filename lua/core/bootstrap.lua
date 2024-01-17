local util = require("core.util")

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

require("core.options")
util.lazy_file()

local plugins = require("plugins.necessary").setup({
    load_plugins = {
        extra = false,
        custom = false,
    }
})

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

require("core.keymaps")
require("core.autocmds")

util.set_colorscheme("catppuccin")
util.lazy_notify()
