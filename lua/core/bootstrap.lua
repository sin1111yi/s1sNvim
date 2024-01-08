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

local plugins = require("plugins.necessary").plugins

local opts = {
    defaults = {
        lazy = false,
        version = "*" -- always use the latest git commit
    },
    checker = {
        enabled = true
    }, -- automatically check for plugin updates
}

require("core.options").set_prefix_opts()

require("lazy").setup(plugins, opts)

require("core.keymaps")
require("core.autocmds")

require("core.options").set_suffix_opts()
