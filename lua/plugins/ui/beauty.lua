local M = {}

M = {
    {
        "karb94/neoscroll.nvim",
        event = "VeryLazy",

        config = function()
            require("neoscroll").setup({
                -- All these keys will be mapped to their corresponding default scrolling animation
                mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
                    '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
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
        enable_named_colors = true,
        enable_tailwind = false,
        config = function()
            vim.api.nvim_create_user_command("ColorHighlight",
                function(opts)
                    local arg = string.lower(opts.fargs[1])
                    if arg == "on" then
                        require("nvim-highlight-colors").turnOn()
                    elseif arg == "off" then
                        require("nvim-highlight-colors").turnOff()
                    elseif arg == "toggle" then
                        require("nvim-highlight-colors").toggle()
                    end
                end,
                {
                    nargs = 1,
                    complete = function()
                        return { "On", "Off", "Toggle" }
                    end,
                    desc = "Config color highlight"
                })

            vim.cmd("ColorHighlight Off")
        end
    }
}

return M
