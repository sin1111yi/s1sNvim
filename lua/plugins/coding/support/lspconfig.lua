local Util = require("core.util")

local M = {}
local _keymaps = {}

---@type lspconfig.options
local lsp_servers_opts = {
    lua_ls = {
        -- Use this to add any additional keymaps
        -- for specific lsp servers
        ---@type LazyKeysSpec[]
        -- keys = {},
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
    },
}

---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
local lsp_servers_setups = {

}

M = {
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
        dependencies = {
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        ---@class PluginLspOpts
        opts = {
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = Util.ui.icons.other.star_4_fill,
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
            -- LSP Server Settings
            ---@type lspconfig.options
            servers = lsp_servers_opts,

            -- additional lsp server setup here
            -- return true if this server shouldn't be setup with lspconfig
            ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
            setup = lsp_servers_setups,
        },

        ---@param opts PluginLspOpts
        config = function(_, opts)
            require("mason").setup()
            require("mason-lspconfig").setup()

            Util.format.register(Util.lsp.formatter())

            -- setup keymaps
            Util.lsp.on_attach(function(client, buffer)
                _keymaps.on_attach(client, buffer)
            end)

            local register_capability = vim.lsp.handlers["client/registerCapability"]

            vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
                local ret = register_capability(err, res, ctx)
                local client_id = ctx.client_id
                ---@type lsp.Client
                local client = vim.lsp.get_client_by_id(client_id)
                local buffer = vim.api.nvim_get_current_buf()
                _keymaps.on_attach(client, buffer)
                return ret
            end

            -- diagnostics
            for name, icon in pairs(Util.ui.icons.diagnostics) do
                name = "DiagnosticSign" .. name
                vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
            end

            if opts.inlay_hints.enabled then
                Util.lsp.on_attach(function(client, buffer)
                    if client.supports_method("textDocument/inlayHint") then
                        Util.toggle.inlay_hints(buffer, true)
                    end
                end)
            end

            if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
                opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
                    or function(diagnostic)
                        local icons = Util.ui.icons.diagnostics
                        for d, icon in pairs(icons) do
                            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                                return icon
                            end
                        end
                    end
            end

            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

            local servers = opts.servers
            local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                has_cmp and cmp_nvim_lsp.default_capabilities() or {},
                opts.capabilities or {}
            )

            local function setup(server)
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(capabilities),
                }, servers[server] or {})

                if opts.setup[server] then
                    if opts.setup[server](server, server_opts) then
                        return
                    end
                elseif opts.setup["*"] then
                    if opts.setup["*"](server, server_opts) then
                        return
                    end
                end
                require("lspconfig")[server].setup(server_opts)
            end

            -- get all the servers that are available through mason-lspconfig
            local have_mason, mlsp = pcall(require, "mason-lspconfig")
            local all_mslp_servers = {}
            if have_mason then
                all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
            end

            local ensure_installed = {} ---@type string[]
            for server, server_opts in pairs(servers) do
                if server_opts then
                    server_opts = server_opts == true and {} or server_opts
                    -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
                    if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
                        setup(server)
                    else
                        ensure_installed[#ensure_installed + 1] = server
                    end
                end
            end

            if have_mason then
                mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
            end
            -- end of config
        end

    },

    {

        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        opts = {
            ---@type string[]
            ensure_installed = {
                -- lua
                "lua-language-server",
                "stylua",
                -- C/C++
                "clangd",
                "clang-format",
                "cmake-language-server",
                "cmakelang",
                -- rust
                "rust-analyzer",
            },
        },

        ---@param opts MasonSettings | {ensure_installed: string[]}
        config = function(_, opts)
            -- when using linux, install some additional LSPs
            if Util.os_is("Linux") then
                local linux_sup_tb = {
                    "bash-language-server",
                    "checkmake"
                }
                for _, v in ipairs(linux_sup_tb) do
                    table.insert(opts.ensure_installed, v)
                end
            end

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

---@type LazyKeysLspSpec[] | nil
_keymaps._keys = nil

---@alias LazyKeysLspSpec LazyKeysSpec|{has?:string}
---@alias LazyKeysLsp LazyKeys|{has?:string}
---@return LazyKeysLspSpec[]
function _keymaps.get()
    if _keymaps._keys then
        return M._keys
    end
    _keymaps._keys = {
        { "<leader>cl", "<cmd>LspInfo<cr>",                                                                     desc = "Lsp Info" },
        { "gd",         function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end,      desc = "Goto Definition",       has = "definition" },
        { "gr",         "<cmd>Telescope lsp_references<cr>",                                                    desc = "References" },
        { "gD",         vim.lsp.buf.declaration,                                                                desc = "Goto Declaration" },
        { "gI",         function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end,  desc = "Goto Implementation" },
        { "gy",         function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto T[y]pe Definition" },
        { "K",          vim.lsp.buf.hover,                                                                      desc = "Hover" },
        { "gK",         vim.lsp.buf.signature_help,                                                             desc = "Signature Help",        has = "signatureHelp" },
        { "<c-k>",      vim.lsp.buf.signature_help,                                                             mode = "i",                     desc = "Signature Help", has = "signatureHelp" },
        { "<leader>ca", vim.lsp.buf.code_action,                                                                desc = "Code Action",           mode = { "n", "v" },     has = "codeAction" },
        {
            "<leader>cA",
            function()
                vim.lsp.buf.code_action({
                    context = {
                        only = {
                            "source",
                        },
                        diagnostics = {},
                    },
                })
            end,
            desc = "Source Action",
            has = "codeAction",
        },
        { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" }
    }
    return _keymaps._keys
end

---@param method string
function _keymaps.has(buffer, method)
    method = method:find("/") and method or "textDocument/" .. method
    local clients = require("core.util").lsp.get_clients({ bufnr = buffer })
    for _, client in ipairs(clients) do
        if client.supports_method(method) then
            return true
        end
    end
    return false
end

---@return (LazyKeys|{has?:string})[]
function _keymaps.resolve(buffer)
    local Keys = require("lazy.core.handler.keys")
    if not Keys.resolve then
        return {}
    end
    local spec = _keymaps.get()
    local opts = require("core.util").opts("nvim-lspconfig")
    local clients = require("core.util").lsp.get_clients({ bufnr = buffer })
    for _, client in ipairs(clients) do
        local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
        vim.list_extend(spec, maps)
    end
    return Keys.resolve(spec)
end

function _keymaps.on_attach(_, buffer)
    local Keys = require("lazy.core.handler.keys")
    local keymaps = _keymaps.resolve(buffer)

    for _, keys in pairs(keymaps) do
        if not keys.has or _keymaps.has(buffer, keys.has) then
            local opts = Keys.opts(keys)
            opts.has = nil
            opts.silent = opts.silent ~= false
            opts.buffer = buffer
            vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
        end
    end
end

return M
