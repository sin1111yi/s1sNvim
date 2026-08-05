-- plugins/conform.lua — Code formatting (conform.nvim)
-- Loaded on UIEnter (once).
-- Format on save with LSP fallback; manual format via <leader>xf.
-- Formatters (stylua/ruff/rustfmt/clang-format/etc.) must be installed
-- (Mason or system packages).

local U = require("config.util")
return U.try_load("conform", function(conform)
	conform.setup({
		formatters_by_ft = {
			lua = { "stylua" },
			rust = { "rustfmt" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			sh = { "shfmt" },
			toml = { "taplo" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	})
end)
