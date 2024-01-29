local M = {}

local Util = require("core.util")

local _formatters = {}

---@param name string
_formatters.get_executable = function(name)
    if vim.fn.executable(name) == 1 then
        return name
    else
        if Util.has("mason.nvim") then
            Util.warn(("%s is absent, trying to install is through 'MasonInstall %s'"):format(name, name))
        else
            Util.warn(("%s is absent, please make sure it has been installed!"):format(name))
        end
    end

    return nil
end

---@class FormattingBufInfo
---@field bufnr integer
---@field bufpath string
---@field file_name string
---@field file_dir string
---@field file_extension string

---@return FormattingBufInfo
_formatters.get_formatting_buffer = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local bufname = vim.api.nvim_buf_get_name(bufnr)

    ---@type FormattingBufInfo
    return {
        bufnr = bufnr,
        bufpath = bufname,
        file_name = vim.fn.shellescape(vim.fn.fnamemodify(bufname, ":t"), true),
        file_dir = vim.fn.shellescape(vim.fn.fnamemodify(bufname, ":h"), true),
        file_extension = vim.fn.shellescape(vim.fn.fnamemodify(bufname, ":e"), true),
    }
end

---@type table<string, fun(nil):table>
_formatters.setup = {
    ["stylua"] = function()
        return {
            exe = _formatters.get_executable("stylua"),
            args = {
                "--search-parent-directories",
                "--indent-type=Spaces",
                "--indent-width=4",
                "--quote-style=AutoPreferDouble",
                string.format("--stdin-filepath=%s", _formatters.get_formatting_buffer().bufpath),
                "--",
                "-",
            },
            stdin = true,
        }
    end,
}

M = {
    {
        "mhartington/formatter.nvim",
        event = "LazyFile",
        config = function()
            require("formatter").setup({
                logging = true,
                log_level = vim.log.levels.WARN,
                filetype = {
                    lua = _formatters.setup["stylua"],
                },
            })
        end,
    },
}

return M
