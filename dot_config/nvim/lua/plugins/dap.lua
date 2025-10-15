return {
	"mfussenegger/nvim-dap",
	lazy = false,
	config = function()
		local dap = require("dap")

		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",

				args = {
					"/home/robbie/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
					"${port}",
				},
			},
		}

		dap.configurations.javascript = {
			{
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
			},
		}
	end,
}
