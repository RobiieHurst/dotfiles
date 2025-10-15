return {
	{
		"tpope/vim-dadbod",
		lazy = true,
		cmd = { "DB", "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		lazy = true,
		dependencies = { "tpope/vim-dadbod" },
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		keys = {
			{ "<leader>du", ":DBUIToggle<CR>", desc = "Toggle Dadbod UI" },
			{ "<leader>da", ":DBUIAddConnection<CR>", desc = "Add DB Connection" },
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},
	{
		"kristijanhusak/vim-dadbod-completion",
		ft = { "sql", "mysql", "plsql" },
		dependencies = { "tpope/vim-dadbod" },
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "sql" },
				callback = function()
					require("cmp").setup.buffer({
						sources = {
							{ name = "vim-dadbod-completion" },
							{ name = "buffer" },
						},
					})
				end,
			})
		end,
	},
}

