local util = require("core.util")
local wk = require("which-key")

wk.register({
    e = { "<cmd>Neotree toggle<cr>", "Neo Tree Toggle" },

    x = {
        name = "+Extra",
        l = { "<cmd>Lazy<cr>", "Lazy" },
    },

    s = {
        name = "+Search",
        l = { "<cmd>Legendary<cr>", "Legendary" }
    },

    b = {
        name = "+Buffer",
        d = { "<cmd>lua require('core.plugins.exapi').bufdel.del_current()<cr>", "Delete Current" },
        o = { "<cmd>lua require('core.plugins.exapi').bufdel.del_others()<cr>", "Delete Others" }
    }

}, { prefix = "<leader>" })
