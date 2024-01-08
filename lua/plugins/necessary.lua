local M = {}

M.plugins = {
    {
        "nvim-lua/plenary.nvim"
    },

    { import = "plugins.colorscheme" },
    { import = "plugins.support" },
    { import = "plugins.ui" },

    { import = "plugins.custom" },
}

return M
