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
                ["Y"] = function(state)
                    local node = state.tree:get_node()
                    local path = node:get_id()
                    vim.fn.setreg("+", path, "c")
                end,
                ["<2-LeftMouse>"] = "open",
                ["<cr>"] = "open",
                ["<esc>"] = "cancel", -- close preview or floating neo-tree window
                ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
                -- Read `# Preview Mode` for more information
                ["l"] = "focus_preview",
                ["S"] = "split_with_window_picker",
                ["s"] = "vsplit_with_window_picker",
                ["t"] = "open_tabnew",
                ["w"] = "open_with_window_picker",
                ["C"] = "close_node",
                ["z"] = "close_all_nodes",
                ["Z"] = "expand_all_nodes",
                ["a"] = {
                    "add",
                    -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
                    -- some commands may take optional config options, see `:h neo-tree-mappings` for details
                    config = {
                        show_path = "none" -- "none", "relative", "absolute"
                    }
                },
                ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
                ["d"] = "delete",
                ["r"] = "rename",
                ["y"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
                ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
                ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
                ["q"] = "close_window",
                ["R"] = "refresh",
                ["?"] = "show_help",
                ["<"] = "prev_source",
                [">"] = "next_source",
                ["i"] = "show_file_details",
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
