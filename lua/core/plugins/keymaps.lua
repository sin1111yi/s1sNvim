local util = require("core.util")
local wk = require("which-key")

wk.register({

    b = {
        name = "+Buffer",
        d = { "<cmd>lua require('core.plugins.exapi').buf_del.del_current()<cr>", "Delete current" },
        o = { "<cmd>lua require('core.plugins.exapi').buf_del.del_others()<cr>", "Delete others" },
        l = { "<cmd>lua require('core.plugins.exapi').buf_del.del_matches('left')<cr>", "Delete left" },
        h = { "<cmd>lua require('core.plugins.exapi').buf_del.del_matches('right')<cr>", "Delete right" },
        b = { "<cmd>lua require('core.plugins.exapi').buf_del.del_matches('all')<cr>", "Delete all" }
    },

    e = { "<cmd>Neotree toggle<cr>", "Neo-Tree toggle" },

    s = {
        name = "+Search",
        l = { "<cmd>Legendary<cr>", "Legendary" }
    },

    w = {
        name = "+Window",
    },

    q = {
        name = "+Extra",
        l = { "<cmd>Lazy<cr>", "Lazy" },
    },

}, { prefix = "<leader>" })
