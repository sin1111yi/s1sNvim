local M = {}

M = {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
        flavour = "macchiato", -- latte, frappe, macchiato, mocha
        background = {         -- :h background
            light = "latte",
            dark = "mocha",
        },

        transparent_background = false,     -- disables setting the background color.
        show_end_of_buffer = false,         -- shows the '~' characters after the end of buffers
        term_colors = false,                -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
            enabled = false,                -- dims the background color of inactive window
            shade = "dark",
            percentage = 0.15,              -- percentage of the shade to apply to the inactive window
        },
        no_italic = false,                  -- Force no italic
        no_bold = false,                    -- Force no bold
        no_underline = false,               -- Force no underline
        styles = {                          -- Handles the styles of general hi groups (see `:h highlight-args`):
            comments = { args = "italic" }, -- Change the style of comments
            conditionals = { args = "italic" },
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
        },
        color_overrides = {},
        custom_highlights = {},
        integrations = {
            cmp = true,
            gitsigns = true,
            indent_blankline = { enabled = true },
            mason = true,
            neotree = true,
            noice = true,
            notify = true,
            telescope = true,
            treesitter = true,
            treesitter_context = true,
            which_key = true,
        },
    },
}
return M
