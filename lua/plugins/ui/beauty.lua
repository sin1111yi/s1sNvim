local M = {}

M = {
    {
        "karb94/neoscroll.nvim",
        event = "VeryLazy",
        config = function()
            require("neoscroll").setup({
                hide_cursor = true,          -- Hide cursor while scrolling
                stop_eof = true,             -- Stop at <EOF> when scrolling downwards
                respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
                cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
                easing_function = nil,       -- Default easing function
                pre_hook = nil,              -- Function to run before the scrolling animation starts
                post_hook = nil,             -- Function to run after the scrolling animation ends
                performance_mode = false,    -- Disable "Performance Mode" on all buffers.
            })
        end
    },

    {
        "j-hui/fidget.nvim",
        event = "VeryLazy",
        config = function()
            require("fidget").setup()
        end
    },

    {
        "brenoprata10/nvim-highlight-colors",
        event = { "BufAdd", "BufEnter", "BufRead" },
        opts = {
            enable_named_colors = true,
            enable_tailwind = false,
        },
        config = function()
            require("nvim-highlight-colors").setup()
        end
    },

    {
        "gen740/SmoothCursor.nvim",
        lazy = false,
        config = function()
            require("smoothcursor").setup({
                cursor = "󱞪",
                fancy = {
                    enable = false,
                }
            })
        end
    }
}

return M
