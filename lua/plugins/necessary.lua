local M = {}

M.plugins = {
    { import = "plugins.support" },
    { import = "plugins.colorscheme" },
    { import = "plugins.ui" },

    { import = "plugins.custom" },
}

return M
