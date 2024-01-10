local M = {}

M = {
    "folke/neodev.nvim",
    opts = {
        {
            library = {
                enabled = true,
                runtime = true,
                types = true,
                plugins = true,
            },
            setup_jsonls = true,
            lspconfig = true,
            pathStrict = true,
        }
    }
}

return M
