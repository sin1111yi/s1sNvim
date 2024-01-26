local M = {}

local Util = require("core.util")

M = {
    {
        "stevearc/aerial.nvim",
        event = { "LazyFile" },
        opts = {
            layout = {
                max_width = { 40, 0.3 },
                width = 40,
                min_width = 10,
                default_direction = "prefer_right",
                placement = "edge",
                resize_to_content = true,
                preserve_equality = false,
            },
        },
        config = function()
            require("aerial").setup()

            Util.on_load("telescope.nvim", function()
                require("telescope").load_extension("aerial")
            end)
        end
    }
}

return M
