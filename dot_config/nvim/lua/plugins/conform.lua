return {
	"stevearc/conform.nvim",
	dependencies = { "mason.nvim" },
	lazy = true,
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cF",
			function()
				require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
			end,
			mode = { "n", "v" },
			desc = "Format Injected Langs",
		},
	},
	init = function()
		-- Register conform.nvim with LazyVim's formatting system
		LazyVim.on_very_lazy(function()
			LazyVim.format.register({
				name = "conform.nvim",
				priority = 100,
				primary = true,
				format = function(buf)
					-- Skip formatting for .env files
					local filename = vim.api.nvim_buf_get_name(buf)
					if filename:match("%.env") or filename:match("%.env%.") then
						return
					end
					require("conform").format({ bufnr = buf })
				end,
				sources = function(buf)
					-- Skip listing formatters for .env files
					local filename = vim.api.nvim_buf_get_name(buf)
					if filename:match("%.env") or filename:match("%.env%.") then
						return {}
					end
					local ret = require("conform").list_formatters(buf)
					return vim.tbl_map(function(v)
						return v.name
					end, ret)
				end,
			})
		end)
	end,
	opts = {
		default_format_opts = {
			timeout_ms = 3000,
			async = false,
			quiet = false,
			lsp_format = "fallback",
		},
		formatters_by_ft = {
			lua = { "stylua" },
			rust = { "rustfmt", lsp_format = "fallback" },
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
			injected = { options = { ignore_errors = true } },
		},
	},
}
