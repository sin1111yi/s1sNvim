local M = {}

local util = require("core.util")

M.lsp_servers_conf = {
    lua_ls = {
        settings = {
            Lua = {
                workspace = {
                    checkThirdParty = false,
                },
                completion = {
                    callSnippet = "Replace",
                },
            },
        },
    }
}

M = {
    {
        "neovim/nvim-lspconfig",
        event = "LazyFile",
        dependencies = {
            {
                "folke/neoconf.nvim",
                cmd = "Neoconf",
                config = false,
                dependencies = { "nvim-lspconfig" }
            },
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        opts = {
            diagnostic = {
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = util.icons.other.star_4_fill
                },
                severity_sort = true,
            },
            inlay_hints = {
                enabled = false,
            },
            capabilities = {},
            format = {
                formatting_options = nil,
                timeout_ms = nil,
            },
            servers = M.lsp_servers_conf,

            setup = {},
        },

        ---@param opts PluginLspOpts
        config = function(_, opts)
            if util.has("neoconf.nvim") then
                local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
                require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
            end
        end

    },

    {

        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        opts = {
            ---@type string[]
            ensure_installed = {
                -- bash
                "bash-language-server",
                -- lua
                "lua-language-server",
                "stylua",
                -- C/C++
                "clangd",
                "clang-format",
                "checkmake",
                "cmake-language-server",
                "cmakelang",
                -- rust
                "rust-analyzer",
            },
        },

        ---@param opts MasonSettings | {ensure_installed: string[]}
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require("mason-registry")
            mr:on("package:install:success", function()
                vim.defer_fn(function()
                    -- trigger FileType event to possibly load this newly installed LSP server
                    require("lazy.core.handler.event").trigger({
                        event = "FileType",
                        buf = vim.api.nvim_get_current_buf(),
                    })
                end, 100)
            end)
            local function ensure_installed()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end
        end,
    },
}

return M
