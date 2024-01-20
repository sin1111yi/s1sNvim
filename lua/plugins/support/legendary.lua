local M = {}

M =
{
    'mrjones2014/legendary.nvim',
    priority = 10000,
    lazy = false,
    config = function ()
        require("legendary").setup({
            extensions = {
                which_key = {
                    auto_register = true,
                    do_binding = false,
                    use_groups = false,
                },
                nvim_tree = true,
                lazy_nvim = true,
            }
        })
    end
}

return M
