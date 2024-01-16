local util = require("core.util")
local wk = require("which-key")

wk.register({
    e = { "<cmd>Neotree toggle<cr>", "Neo Tree Toggle" },

    x = {
        name = "+Extra",
        l = { "<cmd>Lazy<cr>", "Lazy" },
        t = {
            function()
                util.ftest()
            end, "Test" }
    },

    s = {
        name = "+Search",
        l = { "<cmd>Legendary<cr>", "Legendary" }
    },

    b = {
        name = "+Buffer",
        d = { "<cmd>bd<cr>", "Delete Current" }
    }

}, { prefix = "<leader>" })
