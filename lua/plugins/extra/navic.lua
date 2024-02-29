local M = {}

local Util = require("core.util")

M = {
    -- a statusline/winbar to show code context using LSP
    {
        "SmiteshP/nvim-navic",
        event = { "BufAdd", "BufEnter", "BufNew" },
        init = function()
            vim.g.navic_silence = true
            Util.lsp.on_attach(function(client, buffer)
                if client.supports_method("textDocument/documentSymbol") then
                    require("nvim-navic").attach(client, buffer)
                end
            end)
        end,
        opts = function()
            return {
                separator = " ",
                highlight = true,
                depth_limit = 5,
                icons = Util.ui.icons.kinds,
                lazy_update_context = true,
            }
        end,
    },

    {
        "nvim-lualine/lualine.nvim",
        optional = true,
        opts = function(_, opts)
            table.insert(opts.sections.lualine_c, {
                function()
                    return require("nvim-navic").get_location()
                end,
                cond = function()
                    return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
                end,
            })
        end,
    }
}

return M
