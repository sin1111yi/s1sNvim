local Util = require("core.util")

local _map = {}

local vmap = Util.better_nvim_keymap_set
local smap = Util.safe_keymap_set

_map.tb = {
    ["leader"] = {
        b = {
            name = "+Buffer",
            d = { "<cmd>lua require('core.plugins.exapi').buf_del.del_current()<cr>", "Delete current" },
            o = { "<cmd>lua require('core.plugins.exapi').buf_del.del_others()<cr>", "Delete others" },
            l = { "<cmd>lua require('core.plugins.exapi').buf_del.del_matches('left')<cr>", "Delete left" },
            h = { "<cmd>lua require('core.plugins.exapi').buf_del.del_matches('right')<cr>", "Delete right" },
            b = { "<cmd>lua require('core.plugins.exapi').buf_del.del_matches('all')<cr>", "Delete all" },
            e = {
                function()
                    require("neo-tree.command").execute({ source = "buffers", toggle = true })
                end, "Explorer buffers" },
            s = { "<cmd>ls<cr>", "List all" }
        },

        c = {
            name = "+Code"
        },

        f = {
            name = "+File",
            e = {
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = Util.root() })
                end, "Explorer root dir" },
            E = {
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
                end, "Explorer cwd" },
        },

        g = {
            name = "+Git",
            e = {
                function()
                    require("neo-tree.command").execute({ source = "git_status", toggle = true })
                end, "Git explorer" },
            h = {
                name = "Gitsigns"
            }
        },

        p = {
            name = "+Plugins",
            l = { "<cmd>Lazy<cr>", "Lazy" },
            m = { "<cmd>Mason<cr>", "Mason" },
            u = { "<cmd>UpdateAll<cr>", "Update all" }
        },

        s = {
            name = "+Search",
            l = { "<cmd>Legendary<cr>", "Legendary" },
            r = { function() require("spectre").open() end, "Replace in files" }
        },

        w = {
            name = "+Window",
        },
    }
}

_map.opts = {
    ["leader"] = { prefix = "<leader>" }
}

vmap("n", "<leader>e", "<leader>fe", { desc = "Explorer root dir" })
vmap("n", "<leader>E", "<leader>fE", { desc = "Explorer cwd" })

require("which-key").register(_map.tb["leader"], _map.opts["leader"])

if Util.has("neoscorll") then
    local _neoscorll_keymap = {
        ["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "250" } },
        ["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "250" } },
        ["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "450" } },
        ["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "450" } },
        ["<C-y>"] = { "scroll", { "-0.10", "false", "100" } },
        ["<C-e>"] = { "scroll", { "0.10", "false", "100" } },
        ["zt"]    = { "zt", { "250" } },
        ["zz"]    = { "zz", { "250" } },
        ["zb"]    = { "zb", { "250" } },
    }

    require("neoscroll.config").set_mappings(_neoscorll_keymap)
else
    smap("n", "<c-u>", "10k", { desc = "Scroll up" })
    smap("n", "<c-d>", "10j", { desc = "Scroll up" })
end
