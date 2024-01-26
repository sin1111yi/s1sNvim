local M = {}

local Util = require("core.util")

M.formatter_path = nil

M = {
    {
        "sbdchd/neoformat",
        event = { "LazyFile" },
        init = function()
            if Util.has("mason") then
                M.formatter_path = function()
                    local mason_path = require("mason.settings").current.install_root_dir
                    return path.concat { mason_path, "bin" }
                end
            end
        end,

        config = function()

        end
    }
}

return M
