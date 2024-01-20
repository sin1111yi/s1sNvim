local Util = require("core.util")

local _map = {}

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
                end, "Git explorer" }
        },

        p = {
            name = "+Plugins",
            l = { "<cmd>Lazy<cr>", "Lazy" },
            m = { "<cmd>Mason<cr>", "Mason" }
        },

        s = {
            name = "+Search",
            l = { "<cmd>Legendary<cr>", "Legendary" }
        },

        w = {
            name = "+Window",
        },
    }
}

_map.opts = {
    ["leader"] = { prefix = "<leader>" }
}

require("which-key").register(_map.tb["leader"], _map.opts["leader"])
