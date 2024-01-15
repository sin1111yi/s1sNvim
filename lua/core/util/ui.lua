---@class core.util.ui
local M = {}

---@param colorscheme string
M.set_colorscheme = function(colorscheme)
    vim.cmd.colorscheme { colorscheme }
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

-- Common kill function for bdelete and bwipeout
-- credits: based on bbye and nvim-bufdel
-- based on https://github.com/LunarVim/LunarVim/blob/master/lua/lvim/core/bufferline.lua
---@param cmd? string defaults to "bd"
---@param bufnr? number defaults to the current buffer
---@param force? boolean defaults to false
M.better_buffer_delete = function(cmd, bufnr, force)
    cmd = cmd or "bd"

    if bufnr == 0 or bufnr == nil then
        bufnr = vim.api.nvim_get_current_buf()
    end

    local bufname = vim.api.nvim_buf_get_name(bufnr)

    if not force then
        if vim.bo[bufnr].modified then
            local choice = vim.fn.confirm(fmt([[Save changes to "%s"?]], bufname), "&Yes\n&No\n&Cancel")
            if choice == 1 then
                vim.api.nvim_buf_call(bufnr, function()
                    vim.cmd("w")
                end)
            elseif choice == 2 then
                force = true
            else
                return
            end
        elseif vim.api.nvim_buf_get_option(bufnr, "buftype") == "terminal" then
            force = true
        end
    end

    -- Get list of windows IDs with the buffer to close
    local windows = vim.tbl_filter(function(window)
        return vim.api.nvim_win_get_buf(window) == bufnr
    end, vim.api.nvim_lists_wins())

    if force then
        cmd = cmd .. "!"
    end

    -- Get list of active buffers
    local buffers = vim.tbl_filter(function(buf)
        return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
    end, vim.api.nvim_list_bufs())

    -- If there is only one buffer (which has to be the current one), vim will
    -- create a new buffer on :bd.
    -- For more than one buffer, pick the previous buffer (wrapping around if necessary)
    if #buffers > 1 and #windows > 0 then
        for i, v in ipairs(buffers) do
            if v == bufnr then
                local prev_buf_idx = i == 1 and #buffers or (i - 1)
                local prev_buffer = buffers[prev_buf_idx]
                for _, win in ipairs(windows) do
                    vim.api.nvim_win_set_buf(win, prev_buffer)
                end
            end
        end
    end

    -- Check if buffer still exists, to ensure the target buffer wasn't killed
    -- due to options like bufhidden=wipe.
    if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
        vim.cmd(string.format("%s %d", cmd, bufnr))
    end
end

return M
