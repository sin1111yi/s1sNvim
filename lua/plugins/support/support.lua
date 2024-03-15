local M = {}

M = {
    {
        "nathom/filetype.nvim",
        lazy = false,
    },

    {
        "nvim-lua/plenary.nvim",
        lazy = true,
    },

    {
        "mg979/vim-visual-multi",
        event = { "WinNew" }
    }
}

return M
