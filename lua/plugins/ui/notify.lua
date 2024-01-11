local M = {}

local util = require("core.util")

M = {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
        background_colour = "#2f2f2f00",
        timeout = 3000,
        max_height = function()
            return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
            return math.floor(vim.o.columns * 0.75)
        end,
        on_open = function(win)
            vim.api.nvim_win_set_config(win, { zindex = 100 })
        end,
    },

    init = function()
        -- when noice is not enabled, install notify on VeryLazy
        if not util.has("noice.nvim") then
            util.on_very_lazy(function()
                -- replace notify with nvim-notify
                vim.notify = require("notify")
            end)
        end
    end,
}

return M
