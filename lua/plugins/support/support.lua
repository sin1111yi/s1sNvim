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
        "farmergreg/vim-lastplace",
        event = { "BufAdd", "BufEnter", "BufNew" }
    }
}

return M
