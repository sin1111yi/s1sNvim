local Util = require("core.util")

---@class core.util.ui
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

        oct_dot           = "",
        oct_dot_fill      = "",
    },

    git_status = {
        -- Change type
        added     = "",
        modified  = "",
        deleted   = "",
        renamed   = "󰁕",

        -- Status type
        untracked = "",
        ignored   = "",
        unstaged  = "󰄱",
        staged    = "",
        conflict  = "",
    },

    diagnostics = {
        Error = "",
        Warn  = "",
        Hint  = "",
        Info  = "",
    },

    other = {
        gear        = "",
        flash       = "",
        check       = "",
        close       = "",
        code        = "",
        star_3      = "󰫥",
        star_4      = "󰫣",
        star_3_fill = "󰫤",
        star_4_fill = "󰫢",
    },
}

---@param colorscheme string | fun()
M.set_colorscheme = function(colorscheme)
    Util.track("colorscheme")
    Util.try(function()
        if type(colorscheme) == "function" then
            colorscheme()
        elseif type(colorscheme) == "string" then
            vim.cmd.colorscheme(colorscheme)
        end
    end, {
        msg = "Could not load colorscheme",
        on_error = function(msg)
            Util.error(msg)
            vim.cmd.colorscheme("catppuccin")
        end,
    })
    Util.track()
end

---@alias Sign {name:string, text:string, texthl:string, priority:number}

-- Returns a list of regular and extmark signs sorted by priority (low to high)
---@return Sign[]
---@param buf number
---@param lnum number
M.get_signs = function(buf, lnum)
    -- Get regular signs
    ---@type Sign[]
    local signs = vim.tbl_map(function(sign)
        ---@type Sign
        local ret = vim.fn.sign_getdefined(sign.name)[1]
        ret.priority = sign.priority
        return ret
    end, vim.fn.sign_getplaced(buf, { group = "*", lnum = lnum })[1].signs)

    -- Get extmark signs
    local extmarks = vim.api.nvim_buf_get_extmarks(
        buf,
        -1,
        { lnum - 1, 0 },
        { lnum - 1, -1 },
        { details = true, type = "sign" }
    )
    for _, extmark in pairs(extmarks) do
        signs[#signs + 1] = {
            name = extmark[4].sign_hl_group or "",
            text = extmark[4].sign_text,
            texthl = extmark[4].sign_hl_group,
            priority = extmark[4].priority,
        }
    end

    -- Sort by priority
    table.sort(signs, function(a, b)
        return (a.priority or 0) < (b.priority or 0)
    end)

    return signs
end

---@return Sign?
---@param buf number
---@param lnum number
M.get_mark = function(buf, lnum)
    local marks = vim.fn.getmarklist(buf)
    vim.list_extend(marks, vim.fn.getmarklist())
    for _, mark in ipairs(marks) do
        if mark.pos[1] == buf and mark.pos[2] == lnum and mark.mark:match("[a-zA-Z]") then
            return { text = mark.mark:sub(2), texthl = "DiagnosticHint" }
        end
    end
end

---@param sign? Sign
---@param len? number
function M.icon(sign, len)
    sign = sign or {}
    len = len or 2
    local text = vim.fn.strcharpart(sign.text or "", 0, len) ---@type string
    text = text .. string.rep(" ", len - vim.fn.strchars(text))
    return sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
end

M.statuscolumn = function()
    local win = vim.g.statusline_winid
    if vim.wo[win].signcolumn == "no" then
        return ""
    end
    local buf = vim.api.nvim_win_get_buf(win)

    ---@type Sign?,Sign?,Sign?
    local left, right, fold
    for _, s in ipairs(M.get_signs(buf, vim.v.lnum)) do
        if s.name and s.name:find("GitSign") then
            right = s
        else
            left = s
        end
    end

    if vim.v.virtnum ~= 0 then
        left = nil
    end

    vim.api.nvim_win_call(win, function()
        if vim.fn.foldclosed(vim.v.lnum) >= 0 then
            fold = { text = vim.opt.fillchars:get().foldclose or "", texthl = "Folded" }
        end
    end)

    local nu = ""
    if vim.wo[win].number and vim.v.virtnum == 0 then
        nu = vim.wo[win].relativenumber and vim.v.relnum ~= 0 and vim.v.relnum or vim.v.lnum
    end

    return table.concat({
        M.icon(M.get_mark(buf, vim.v.lnum) or left),
        [[%=]],
        nu .. " ",
        M.icon(fold or right),
    }, "")
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

return M
