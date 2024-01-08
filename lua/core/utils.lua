local M = {}

M.icons = {
    misc = {
        -- arrows
        dots              = "󰇘",
        uparrow_bold      = "",
        downarrow_bold    = "",
        leftarrow_bold    = "",
        rightarrow_bold   = "",
        uparrow           = "",
        downarrow         = "",
        leftarrow         = "",
        rightarrow        = "",
        uparrow_double    = "",
        downarrow_double  = "",
        leftarrow_double  = "",
        rightarrow_double = "",

        plus              = "",
        minus             = "",
    },

    git_status = {
        -- Change type
        added     = "✚",
        modified  = "",
        deleted   = "✖",
        renamed   = "󰁕",

        -- Status type
        untracked = "",
        ignored   = "",
        unstaged  = "󰄱",
        staged    = "",
        conflict  = "",
    },

    diagnostic = {
        error = " ",
        warn  = " ",
        info  = " ",
        hint  = "󰌵",
    },

    other = {
        gear  = "",
        flash = "",
        check = "",
        close = "",
        code  = ""
    },
}

M.set_colorscheme = function(colorscheme)
    vim.cmd.colorscheme { colorscheme }
end

M.say_hi = function()
    local async = require("plenary.async")
    local notify = require("notify").async

    async.run(function()
        notify("Do not go gentle into that good night!").events.close()
    end)
end

M.run_update = function()

end

M.fold_text = function()
    local ok = pcall(vim.treesitter.get_parser, vim.api.nvim_get_current_buf())
    local ret = ok and vim.treesitter.foldtext and vim.treesitter.foldtext()
    if not ret or type(ret) == "string" then
        ret = { { vim.api.nvim_buf_get_lines(0, vim.v.lnum - 1, vim.v.lnum, false)[1], {} } }
    end
    table.insert(ret, { " " .. M.icons.misc.dots })

    if not vim.treesitter.foldtext then
        return table.concat(
            vim.tbl_map(function(line)
                return line[1]
            end, ret),
            " "
        )
    end
    return ret
end

M.safe_keymap_set = function(mode, lhs, rhs, opts)
    local keys = require("lazy.core.handler").handlers.keys
    ---@cast keys LazyKeysHandler
    local modes = type(mode) == "string" and { mode } or mode

    ---@param m string
    modes = vim.tbl_filter(function(m)
        return not (keys.have and keys:have(lhs, m))
    end, modes)

    -- do not create the keymap if a lazy keys handler exists
    if #modes > 0 then
        opts = opts or {}
        opts.silent = opts.silent ~= false
        if opts.remap and not vim.g.vscode then
            ---@diagnostic disable-next-line: no-unknown
            opts.remap = nil
        end
        vim.keymap.set(modes, lhs, rhs, opts)
    end
end

M.plugin_exits = function(plugin)
    return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

return M
