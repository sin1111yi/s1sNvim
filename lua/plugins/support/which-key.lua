local M = {}

local icons = require("core.util").ui.icons

M = {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,

    opts = {
        plugins = {
            marks = true,
            registers = true,
            spelling = {
                enabled = true,
                suggestions = 20,
            },
            presets = {
                operators = true,
                motions = true,          -- adds help for motions
                text_objects = true,     -- help for text objects triggered after entering an operator
                windows = true,          -- default bindings on <c-w>
                nav = true,              -- misc bindings to work with windows
                z = true,                -- bindings for folds, spelling and others prefixed with z
                g = true,                -- bindings for prefixed with g
            },
        },
        motions = {
            count = true,
        },
        icons = {
            breadcrumb = icons.misc.rightarrow_double,     -- symbol used in the command line area that shows your active key combo
            separator = icons.misc.rightarrow_bold,        -- symbol used between a key and it's label
            group = icons.misc.plus,                       -- symbol prepended to a group
        },
        popup_mappings = {
            scroll_down = "<c-d>",     -- binding to scroll down inside the popup
            scroll_up = "<c-u>",       -- binding to scroll up inside the popup
        },
        window = {
            border = "none",              -- none, single, double, shadow
            position = "bottom",          -- bottom, top
            margin = { 1, 0, 1, 0 },      -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
            padding = { 1, 2, 1, 2 },     -- extra window padding [top, right, bottom, left]
            winblend = 0,                 -- value between 0-100 0 for fully opaque and 100 for fully transparent
            zindex = 1000,                -- positive value to position WhichKey above other floating windows.
        },
        layout = {
            height = { min = 4, max = 25 },                                                   -- min and max height of the columns
            width = { min = 20, max = 50 },                                                   -- min and max width of the columns
            spacing = 3,                                                                      -- spacing between columns
            align = "left",                                                                   -- align columns left, center or right
        },
        ignore_missing = false,                                                               -- enable this to hide mappings for which you didn't specify a label
        hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " },     -- hide mapping boilerplate
        show_help = true,                                                                     -- show a help message in the command line for using WhichKey
        show_keys = true,                                                                     -- show the currently pressed key and its label as a message in the command line
        triggers = "auto",                                                                    -- automatically setup triggers
        -- triggers = {"<leader>"} -- or specifiy a list manually
        -- list of triggers, where WhichKey should not wait for timeoutlen and show immediately
        triggers_nowait = {
            -- marks
            "`",
            "'",
            "g`",
            "g'",
            -- registers
            '"',
            "<c-r>",
            -- spelling
            "z=",
        },

        triggers_blacklist = {
            i = { "j", "k" },
            v = { "j", "k" },
        },

        disable = {
            -- Disabled by default for Telescope
        },
    }
}

return M
