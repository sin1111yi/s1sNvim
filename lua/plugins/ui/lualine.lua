local M = {}

local Util = require("core.util")
local icons = Util.ui.icons

M = {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        init = function()
            vim.g.lualine_laststatus = vim.o.laststatus
            if vim.fn.argc(-1) > 0 then
                -- set an empty statusline till lualine loads
                vim.o.statusline = " "
            else
                -- hide the statusline on the starter page
                vim.o.laststatus = 0
            end
        end,
        opts = function()
            vim.o.laststatus = vim.g.lualine_laststatus

            return {
                options = {
                    theme = "auto",
                    globalstatus = true,
                    disabled_filetypes = {
                        statusline = {
                            "dashboard",
                            "alpha",
                            "starter" }
                    },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },
                    lualine_c = {
                        {
                            "diagnostics",
                            symbols = {
                                error = icons.diagnostics.Error,
                                warn = icons.diagnostics.Warn,
                                info = icons.diagnostics.Info,
                                hint = icons.diagnostics.Hint,
                            },
                        },
                        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                        {
                            function()
                                return Util.root.pretty_path()
                            end,
                        },
                    },
                    lualine_x = {
                        {
                            function()
                                return require("noice").api.status.command.get()
                            end,
                            cond = function()
                                return package.loaded["noice"] and
                                    require("noice").api.status.command.has()
                            end,
                            color = Util.ui.fg("Statement"),
                        },
                        {
                            function()
                                return require("noice").api.status.mode.get()
                            end,
                            cond = function()
                                return package.loaded["noice"] and require("noice").api.status.mode.has()
                            end,
                            color = Util.ui.fg("Constant"),
                        },
                        {
                            require("lazy.status").updates,
                            cond = require("lazy.status").has_updates,
                            color = Util.ui.fg("Special"),
                        },
                        {
                            "diff",
                            symbols = {
                                added = icons.git_status.added .. " ",
                                modified = icons.git_status.modified .. " ",
                                removed = icons.git_status.removed .. " ",
                            },
                        },
                    },
                    lualine_y = {
                        {
                            "aerial",
                            separator = " ",
                            padding = { left = 1, right = 0 }
                        },
                        {
                            "progress",
                            separator = " ",
                            padding = { left = 0, right = 0 }
                        },
                        {
                            "location",
                            padding = { left = 0, right = 1 }
                        },
                    },
                    lualine_z = {
                        function()
                            return " " .. os.date("%R")
                        end,
                    },
                },
                extensions = { "neo-tree", "lazy" },
            }
        end,
    },
}

return M
