return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		-- Define your formatters
		formatters_by_ft = {
			-- This will provide type hinting with LuaLS
			lua = { "stylua" },
			-- You can customize some of the format options for the filetype (:help conform.format)
			rust = { "rustfmt", lsp_format = "fallback" },
			-- Conform will run the first available formatter
			go = { "gofumpt" },
			javascript = { "biome" },
			typescript = { "biome" },
			typescriptreact = { "biome" },
			javascriptreact = { "biome" },
			json = { "biome" },
			css = { "biome" },
			html = { "biome" },
			vue = { "biome" },
			markdown = { "prettier" },
		},
		formatters = {
			biome = {
				command = vim.fn.resolve(vim.fn.findfile("node_modules/.bin/biome", vim.fn.getcwd() .. ";")) or "biome",
				args = {
					"check",
					"--write",
					"--stdin-file-path",
					"$FILENAME",
				},
			},
			shfmt = {
				prepend_args = { "-i", "2" },
			},
		},
	},
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
