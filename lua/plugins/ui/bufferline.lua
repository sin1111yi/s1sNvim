local M = {}

M = {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    version = "*",
    opts = {
        options = {
            mode = "buffers",
            diagnostics = "nvim_lsp",
            offsets = {
                {
                    filetype = "neo-tree",
                    text = "File Explorer" ,
                    highlight = "Directory",
                    text_align = "left",
                    separator = true
                },
            },
        }
    },

    config = function(_, opts)
        require("bufferline").setup(opts)

        vim.api.nvim_create_autocmd({ "BufAdd", "BufEnter", "BufNew" }, {
            callback = function()
                vim.schedule(function()
                    pcall(nvim_bufferline)
                end)
            end,
        })
    end,
}

return M
