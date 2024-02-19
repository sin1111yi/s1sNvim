local M = {}
local Util = require("core.util")

M = {
    {
        "lewis6991/gitsigns.nvim",
        event = { "LazyFile" },
        dependencies = {
            "petertriho/nvim-scrollbar",
            opts = {
                excluded_buftypes = {
                    "help",
                    "nofile",
                    "terminal",
                    "prompt",
                },
                excluded_filetypes = {
                    "neo-tree",
                    "cmp_docs",
                    "cmp_menu",
                    "noice",
                    "TelescopePrompt",
                },
            }
        },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
        },
        config = function()
            require("gitsigns").setup({})
            if Util.has("nvim-scrollbar") then
                require("scrollbar.handlers.gitsigns").setup()
            end
        end
    }
}

return M
