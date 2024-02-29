local M = {}

local Util = require("core.util")

M = {
    -- code symbol outline
    {
        "stevearc/aerial.nvim",
        event = { "LazyFile" },
        opts = {
            show_guides = true,
            guides = {
                mid_item   = "├╴",
                last_item  = "└╴",
                nested_top = "│ ",
                whitespace = "  ",
            },
            layout = {
                max_width = { 40, 0.3 },
                width = nil,
                min_width = 20,
                default_direction = "prefer_right",
                placement = "edge",
                resize_to_content = true,
                preserve_equality = false,
            },
        },
        config = function()
            require("aerial").setup()
            Util.on_load("telescope.nvim", function()
                require("telescope").load_extension("aerial")
            end)
        end
    },

    -- better diagnostics list and others
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        opts = { use_diagnostic_signs = true },
        keys = {
            {
                "[q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").previous({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cprev)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Previous trouble/quickfix item",
            },
            {
                "]q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").next({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cnext)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Next trouble/quickfix item",
            },
        },
    },

    -- pretty window for navigating LSP locations
    {
        "DNLHC/glance.nvim",
        event = { "LazyFile" },
        config = function()
            local glance = require("glance")
            local actions = glance.actions

            glance.setup({
                height = 18, -- Height of the window
                zindex = 45,

                detached = function(winid)
                    return vim.api.nvim_win_get_width(winid) < 100
                end,

                preview_win_opts = { -- Configure preview window options
                    cursorline = true,
                    number = true,
                    wrap = true,
                },
                border = {
                    enable = false, -- Show window borders. Only horizontal borders allowed
                    top_char = '―',
                    bottom_char = '―',
                },
                list = {
                    position = 'right', -- Position of the list window 'left'|'right'
                    width = 0.33,       -- 33% width relative to the active window, min 0.1, max 0.5
                },
                theme = {               -- This feature might not work properly in nvim-0.7.2
                    enable = true,      -- Will generate colors for the plugin based on your current colorscheme
                    mode = 'auto',      -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
                },
                mappings = {
                    list = {
                        ['j'] = actions.next,     -- Bring the cursor to the next item in the list
                        ['k'] = actions.previous, -- Bring the cursor to the previous item in the list
                        ['<Down>'] = actions.next,
                        ['<Up>'] = actions.previous,
                        ['<Tab>'] = actions.next_location,       -- Bring the cursor to the next location skipping groups in the list
                        ['<S-Tab>'] = actions.previous_location, -- Bring the cursor to the previous location skipping groups in the list
                        ['<C-u>'] = actions.preview_scroll_win(5),
                        ['<C-d>'] = actions.preview_scroll_win(-5),
                        ['v'] = actions.jump_vsplit,
                        ['s'] = actions.jump_split,
                        ['t'] = actions.jump_tab,
                        ['<CR>'] = actions.jump,
                        ['o'] = actions.jump,
                        ['l'] = actions.open_fold,
                        ['h'] = actions.close_fold,
                        ['<leader>l'] = actions.enter_win('preview'), -- Focus preview window
                        ['q'] = actions.close,
                        ['Q'] = actions.close,
                        ['<Esc>'] = actions.close,
                        ['<C-q>'] = actions.quickfix,
                        -- ['<Esc>'] = false -- disable a mapping
                    },
                    preview = {
                        ['Q'] = actions.close,
                        ['<Tab>'] = actions.next_location,
                        ['<S-Tab>'] = actions.previous_location,
                        ['<leader>l'] = actions.enter_win('list'), -- Focus list window
                    },
                },
                hooks = {
                    -- Don't open glance when there is only one result and it is located in the current buffer, open otherwise
                    before_open = function(results, open, jump, method)
                        local uri = vim.uri_from_bufnr(0)
                        if #results == 1 then
                            local target_uri = results[1].uri or results[1].targetUri

                            if target_uri == uri then
                                jump(results[1])
                            else
                                open(results)
                            end
                        else
                            open(results)
                        end
                    end,
                },
                folds = {
                    fold_closed = '',
                    fold_open = '',
                    folded = true, -- Automatically fold list on startup
                },
                indent_lines = {
                    enable = true,
                    icon = '│',
                },
                winbar = {
                    enable = true, -- Available strating from nvim-0.8+
                },
            })
        end
    },
}

return M
