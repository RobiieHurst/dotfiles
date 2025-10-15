return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},

	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		require("fidget").setup({})

		local lspconfig = require("lspconfig")
		local util = require("lspconfig.util")

		lspconfig.lua_ls.setup({
			settings = {
				Lua = {
					runtime = {
						version = "Lua 5.1", -- LÖVE2D uses Lua 5.1
						path = vim.split(package.path, ";"),
					},
					diagnostics = {
						globals = { "vim", "love" }, -- Recognize LÖVE2D's 'love' global
					},
					workspace = {
						userThirdParty = { os.getenv("HOME") .. ".config/love2d-defs" },
						checkThirdParty = "Apply", -- Avoid unnecessary prompts
					},
					telemetry = { enable = false },
				},
			},
		})

		-- Function to resolve local Biome binary
		local function resolve_biome()
			local biome_path = vim.fn.findfile("node_modules/.bin/biome", vim.fn.getcwd() .. ";")
			if biome_path ~= "" then
				return vim.fn.resolve(biome_path)
			end
			vim.notify("Local Biome not found, falling back to global", vim.log.levels.WARN)
			return "biome"
		end

		lspconfig.biome.setup({
			cmd = { resolve_biome(), "lsp-proxy" },
			root_dir = util.root_pattern("biome.json", "package.json"),
			settings = {
				action = {
					useSortedKeys = "on",
					useSortedImports = "on",
				},
			},
		})

		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
				"gopls",
				"marksman",
				"ts_ls",
			},
			handlers = {
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,

				ts_ls = function()
					lspconfig.ts_ls.setup({
						filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
						root_dir = require("lspconfig.util").root_pattern("jsconfig.json", "tsconfig.json", ".git"),
						init_options = {
							preferences = {
								includeCompletionsWithSnippetText = true,
								includeCompletionsForModuleExports = true,
							},
						},
					})
				end,

				marksman = function()
					lspconfig.marksman.setup({
						capabilities = capabilities,
					})
				end,

				zls = function()
					lspconfig.zls.setup({
						root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
						settings = {
							zls = {
								enable_inlay_hints = true,
								enable_snippets = true,
								warn_style = true,
							},
						},
					})
					vim.g.zig_fmt_parse_errors = 0
					vim.g.zig_fmt_autosave = 0
				end,
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
				{ name = "buffer" },
				{ name = "path" },
			}),
		})

		vim.diagnostic.config({
			-- update_in_insert = true,
			virtual_text = true,
			signs = true,
			underline = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end,
}
