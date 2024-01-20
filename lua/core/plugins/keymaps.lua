local Util = require("core.util")

require("which-key").register({

    b = {
        name = "+Buffer",
        d = { "<cmd>lua require('core.plugins.exapi').buf_del.del_current()<cr>", "Delete current" },
        o = { "<cmd>lua require('core.plugins.exapi').buf_del.del_others()<cr>", "Delete others" },
        l = { "<cmd>lua require('core.plugins.exapi').buf_del.del_matches('left')<cr>", "Delete left" },
        h = { "<cmd>lua require('core.plugins.exapi').buf_del.del_matches('right')<cr>", "Delete right" },
        b = { "<cmd>lua require('core.plugins.exapi').buf_del.del_matches('all')<cr>", "Delete all" },
        s = { "<cmd>ls<cr>", "List all" }
    },

    c = {
        name = "+Code"
    },

    e = { "<cmd>Neotree toggle<cr>", "Neo-Tree toggle" },

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

}, { prefix = "<leader>" })
