local M = {}

local util = require("core.util")

M = {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "ahmedkhalf/project.nvim",
            event = "VeryLazy",
            opts = {
                manual_mode = false,
                detection_methods = {
                    "lsp",
                    "pattern"
                },

                patterns = {
                    ".git",
                    "_darcs",
                    ".hg",
                    ".bzr",
                    ".svn",
                    "Makefile",
                    "CMakeLists.txt",
                    "init.lua",
                    "package.json",
                },

                ignore_lsp = {},
                exclude_dirs = {},
                show_hidden = false,
                silent_chdir = true,
                scope_chdir = 'global',
                datapath = vim.fn.stdpath("data"),
            },

            config = function(_, opts)
                require("project_nvim").setup()
                require("core.util").on_load("telescope.nvim", function()
                    require("telescope").load_extension("projects")
                end)
            end
        },
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            enabled = vim.fn.executable("make") == 1,
            config = function()
                util.on_load("telescope.nvim", function()
                    require("telescope").load_extension("fzf")
                end)
            end,
        },
    }
}

return M
