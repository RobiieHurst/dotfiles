vim.api.nvim_create_augroup("DapGroup", { clear = true })

local function navigate(args)
	local buffer = args.buf
	local win_ids = vim.api.nvim_list_wins()
	for _, win_id in ipairs(win_ids) do
		if vim.api.nvim_win_get_buf(win_id) == buffer then
			vim.schedule(function()
				if vim.api.nvim_win_is_valid(win_id) then
					vim.api.nvim_set_current_win(win_id)
				end
			end)
			return
		end
	end
end

local function create_nav_options(name)
	return {
		group = "DapGroup",
		pattern = string.format("*%s*", name),
		callback = navigate,
	}
end

return {
	{
		"mfussenegger/nvim-dap",
		lazy = false,
		dependencies = {
			"mxsdev/nvim-dap-vscode-js",
			{
				"microsoft/vscode-js-debug",
				build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
			},
		},
		config = function()
			local dap = require("dap")

			-- Configure nvim-dap-vscode-js
			require("dap-vscode-js").setup({
				debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
				adapters = {
					"pwa-node",
					"pwa-chrome",
					"pwa-msedge",
					"node-terminal",
					"pwa-extensionHost",
					"node",
					"chrome",
				},
			})

			-- Adapter configurations (only if not handled by mason-nvim-dap)
			for _, adapter in ipairs({ "pwa-node", "pwa-chrome" }) do
				if not dap.adapters[adapter] then
					dap.adapters[adapter] = {
						type = "server",
						host = "localhost",
						port = "${port}",
						executable = {
							command = "node",
							args = {
								vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug-adapter.js",
								"${port}",
							},
						},
					}
				end
			end

			-- Debugging configurations
			for _, lang in ipairs({ "javascript", "typescript" }) do
				dap.configurations[lang] = dap.configurations[lang] or {}
				table.insert(dap.configurations[lang], {
					type = "pwa-chrome",
					request = "launch",
					name = "Launch Chrome against localhost",
					url = "http://localhost:3001",
					webRoot = "${workspaceFolder}",
					sourceMaps = true,
				})
				table.insert(dap.configurations[lang], {
					type = "pwa-node",
					request = "launch",
					name = "Launch Node.js Program",
					program = "${file}",
					cwd = "${workspaceFolder}",
					sourceMaps = true,
					skipFiles = { "<node_internals>/**" },
					resolveSourceMapLocations = {
						"${workspaceFolder}/**",
						"!**/node_modules/**",
					},
				})
				table.insert(dap.configurations[lang], {
					type = "pwa-node",
					request = "launch",
					name = "Launch Node.js App (with static files)",
					program = "${file}",
					cwd = "${workspaceFolder}",
					sourceMaps = true,
					skipFiles = { "<node_internals>/**" },
					resolveSourceMapLocations = {
						"${workspaceFolder}/**",
						"!**/node_modules/**",
					},
					runtimeArgs = {
						"--preserve-symlinks",
						"--preserve-symlinks-main",
					},
					env = {
						NODE_ENV = "development",
					},
					console = "integratedTerminal",
					internalConsoleOptions = "neverOpen",
				})
				table.insert(dap.configurations[lang], {
					type = "pwa-node",
					request = "attach",
					name = "Attach to Node.js Process",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
					sourceMaps = true,
					skipFiles = { "<node_internals>/**" },
				})
			end

			dap.set_log_level("DEBUG")
			vim.keymap.set("n", "<F8>", dap.continue, { desc = "Debug: Continue" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
			vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>B", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Debug: Set Conditional Breakpoint" })

			dap.listeners.before.event_output["remove_ansi"] = function(_, body)
				if body.output then
					body.output = body.output:gsub("\27%[[0-9;]*m", "")
				end
			end
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local layouts = {
				{
					elements = { { id = "scopes" } },
					size = 0.25,
					position = "right",
				},
				{
					elements = { { id = "repl" } },
					size = 0.25,
					position = "bottom",
				},
				{
					elements = { { id = "console" } },
					size = 0.25,
					position = "bottom",
				},
				{
					elements = { { id = "watches" } },
					size = 0.25,
					position = "right",
				},
				{
					elements = { { id = "breakpoints" } },
					size = 0.25,
					position = "right",
				},
				{
					elements = { { id = "stacks" } },
					size = 0.25,
					position = "right",
				},
			}

			local function toggle_debug_ui(name)
				dapui.close()
				for i, layout in ipairs(layouts) do
					if layout.elements[1].id == name then
						dapui.toggle(i)
						return
					end
				end
				error(string.format("bad name: %s", name))
			end

			vim.keymap.set("n", "<leader>dr", function()
				toggle_debug_ui("repl")
			end, { desc = "Debug: toggle repl ui" })
			vim.keymap.set("n", "<leader>ds", function()
				toggle_debug_ui("stacks")
			end, { desc = "Debug: toggle stacks ui" })
			vim.keymap.set("n", "<leader>dw", function()
				toggle_debug_ui("watches")
			end, { desc = "Debug: toggle watches ui" })
			vim.keymap.set("n", "<leader>db", function()
				toggle_debug_ui("breakpoints")
			end, { desc = "Debug: toggle breakpoints ui" })
			vim.keymap.set("n", "<leader>dS", function()
				toggle_debug_ui("scopes")
			end, { desc = "Debug: toggle scopes ui" })
			vim.keymap.set("n", "<leader>dc", function()
				toggle_debug_ui("console")
			end, { desc = "Debug: toggle console ui" })

			vim.api.nvim_create_autocmd("BufEnter", {
				group = "DapGroup",
				pattern = "*dap-repl*",
				callback = function()
					vim.wo.wrap = true
				end,
			})

			vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("dap-repl"))
			vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("DAP Watches"))

			dapui.setup({
				layouts = layouts,
			})

			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
			dap.listeners.after.event_output.dapui_config = function(_, body)
				if body.category == "console" then
					dapui.eval(body.output)
				end
			end
		end,
	},

	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = { "delve", "js-debug-adapter" },
				automatic_installation = true,
				handlers = {
					function(config)
						require("mason-nvim-dap").default_setup(config)
					end,
					delve = function(config)
						table.insert(config.configurations, 1, {
							args = function()
								return vim.split(vim.fn.input("args> "), " ")
							end,
							type = "delve",
							name = "file",
							request = "launch",
							program = "${file}",
							outputMode = "remote",
						})
						table.insert(config.configurations, 1, {
							args = function()
								return vim.split(vim.fn.input("args> "), " ")
							end,
							type = "delve",
							name = "file args",
							request = "launch",
							program = "${file}",
							outputMode = "remote",
						})
						require("mason-nvim-dap").default_setup(config)
					end,
				},
			})
		end,
	},
}
