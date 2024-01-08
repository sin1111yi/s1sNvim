local M = {}

M = {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
        vim.g.lualine_laststatus = vim.o.laststatus
        if vim.fn.argc(-1) > 0 then
            vim.o.statusline = " "
        else
            vim.o.statusline = 0
        end
    end,

    opts = function()
        return {
            options = {
                theme = "auto",
                globalstatus = true,
                disabled_filetypes = {
                    statusline = {
                        "dashboard",
                        "alpha",
                        "starter"
                    }
                },
            }
        }
    end
}

return M
