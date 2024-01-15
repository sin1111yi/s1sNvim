local M = {}

-- https://github.com/LunarVim/LunarVim/blob/master/lua/lvim/core/bufferline.lua

M = {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    version = "*",
    opts = {
        options = {
            mode = "buffers",
            --- name_formatter can be used to change the buffer's label in the bufferline.
            --- Please note some names can/will break the
            --- bufferline so use this at your discretion knowing that it has
            --- some limitations that will *NOT* be fixed.
            name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
                -- remove extension from markdown files for example
                if buf.name:match "%.md" then
                    return vim.fn.fnamemodify(buf.name, ":t:r")
                end
            end,

            diagnostics = "nvim_lsp",
            offsets = {
                {
                    filetype = "neo-tree",
                    text = "File Explorer",
                    highlight = "Directory",
                    text_align = "left",
                    separator = true
                },
            },
            always_show_bufferline = false,
            hover = {
              enabled = false, -- requires nvim 0.8+
              delay = 200,
              reveal = { "close" },
            },
            sort_by = "id",
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
