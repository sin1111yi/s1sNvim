local M = {}

local icons = require("core.util").ui.icons

M = {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    cmd = "Neotree",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        {
            "s1n7ax/nvim-window-picker",
            version = "2.*",
            config = function()
                require "window-picker".setup({
                    hint = "floating-big-letter",
                    selection_chars = "FJDKSLA;CMRUEIWOQP",
                    picker_config = {
                        selection_display = function(char, windowid)
                            return "%=" .. char .. "%=" .. windowid
                        end,

                        use_winbar = "never",
                    },

                    floating_big_letter = {
                        font = "ansi-shadow",
                    },

                    show_prompt = false,

                    filter_rules = {
                        include_current_win = false,
                        autoselect_one = true,
                        -- filter using buffer options
                        bo = {
                            -- if the file type is one of following, the window will be ignored
                            filetype = {
                                "neo-tree",
                                "neo-tree-popup",
                                "notify"
                            },
                            -- if the buffer type is one of following, the window will be ignored
                            buftype = {
                                "terminal",
                                "quickfix"
                            },
                        },
                    },
                })
            end,
        },
    },

    deactivate = function()
        vim.cmd([[Neotree close]])
    end,

    init = function()
        if vim.fn.argc(-1) == 1 then
            local stat = vim.loop.fs_stat(vim.fn.argv(0))
            if stat and stat.type == "directory" then
                require("neo-tree")
            end
        end
    end,

    opts = {
        sources = {
            "filesystem",
            "buffers",
            "git_status",
            "document_symbols"
        },

        open_files_do_not_replace_types = {
            "terminal",
            "Trouble",
            "trouble",
            "qf",
            "Outline"
        },

        filesystem = {
            bind_to_cwd = false,
            follow_current_file = { enabled = true },
            use_libuv_file_watcher = true,
        },
        window = {
            mappings = {
                ["<space>"] = "none",
            },
        },
        default_component_configs = {
            indent = {
                with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                expander_collapsed = "",
                expander_expanded = "",
                expander_highlight = "NeoTreeExpander",
            },
        },
    },
    config = function(_, opts)
        local function on_move(data)
            Util.lsp.on_rename(data.source, data.destination)
        end

        local events = require("neo-tree.events")
        opts.event_handlers = opts.event_handlers or {}
        vim.list_extend(opts.event_handlers, {
            { event = events.FILE_MOVED,   handler = on_move },
            { event = events.FILE_RENAMED, handler = on_move },
        })
        require("neo-tree").setup(opts)
        vim.api.nvim_create_autocmd("TermClose", {
            pattern = "*lazygit",
            callback = function()
                if package.loaded["neo-tree.sources.git_status"] then
                    require("neo-tree.sources.git_status").refresh()
                end
            end,
        })
    end,
}

return M
