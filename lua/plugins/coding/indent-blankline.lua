local M = {}

local color = {}

color.highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

color.hooks = nil

M = {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "LazyFile",
        dependencies = {
            "HiPhish/rainbow-delimiters.nvim",
            {
                "nmac427/guess-indent.nvim",
                opts = {
                    autocmd = true,
                    filetype_exclude = {
                        "netrw",
                        "tutor",
                        "neo-tree",
                    },
                    buftype_exclude = {
                        "help",
                        "nofile",
                        "terminal",
                        "prompt",
                    },
                    config = function()
                        require("guess-indent").setup()
                    end
                }
            }
        },
        opts = {
            indent = {
                char = "│",
                tab_char = "│",
            },
            scope = { enabled = false },
            exclude = {
                filetypes = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
            },
        },

        config = function()
            color.hooks = require("ibl.hooks")
            color.hooks.register(color.hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
                vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
                vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
                vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
                vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
                vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
                vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
            end)

            vim.g.rainbow_delimiters = { highlight = color.highlight }
            require("ibl").setup {
                scope = { highlight = color.highlight },
                -- indent = { highlight = color.highlight }
            }

            color.hooks.register(color.hooks.type.SCOPE_HIGHLIGHT, color.hooks.builtin.scope_highlight_from_extmark)
        end
    }
}

return M
