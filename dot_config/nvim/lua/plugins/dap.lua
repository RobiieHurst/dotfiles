-- JS/TS debugging via vscode-js-debug (js-debug-adapter from Mason).
-- Uses `opts` instead of `config` so LazyVim's own dap setup (signs, dap-ui
-- auto open/close, launch.json support) stays intact.
local js_filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }

return {
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {
      -- show values inline next to the variable itself, not at end of line
      virt_text_pos = "inline",
      highlight_changed_variables = true,
      highlight_new_as_changed = true,
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    opts = {
      layouts = {
        -- sidebar dominated by scopes; stacks/breakpoints live in the
        -- <leader>df float picker instead
        {
          elements = {
            { id = "scopes", size = 0.7 },
            { id = "watches", size = 0.3 },
          },
          position = "left",
          size = 45,
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          position = "bottom",
          size = 12,
        },
      },
    },
    keys = {
      -- <leader>du (LazyVim) toggles everything; these toggle window groups
      { "<leader>dv", function() require("dapui").float_element("scopes", { enter = true }) end, desc = "View Scopes (float)" },
      { "<leader>d1", function() require("dapui").toggle({ layout = 1 }) end, desc = "Toggle Sidebar (scopes/watches)" },
      { "<leader>d2", function() require("dapui").toggle({ layout = 2 }) end, desc = "Toggle Bottom Panel (repl/console)" },
      {
        "<leader>df",
        function()
          local elements = { "scopes", "watches", "stacks", "breakpoints", "repl", "console" }
          vim.ui.select(elements, { prompt = "Float DAP element:" }, function(el)
            if el then
              require("dapui").float_element(el, { enter = true })
            end
          end)
        end,
        desc = "Float DAP Element",
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
    },
    opts = function()
      local dap = require("dap")

      for _, adapter in ipairs({ "pwa-node", "pwa-chrome" }) do
        dap.adapters[adapter] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "js-debug-adapter",
            args = { "${port}" },
          },
        }
      end

      -- let .vscode/launch.json entries with these types apply to JS/TS buffers
      local vscode = require("dap.ext.vscode")
      for _, type in ipairs({ "node", "chrome", "pwa-node", "pwa-chrome" }) do
        vscode.type_to_filetypes[type] = js_filetypes
      end

      local skip_files = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" }

      for _, ft in ipairs(js_filetypes) do
        dap.configurations[ft] = {
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Chrome: debug web app",
            url = function()
              return vim.fn.input("Dev server URL: ", "http://localhost:3000")
            end,
            webRoot = "${workspaceFolder}",
            runtimeExecutable = "/usr/bin/chromium",
            sourceMaps = true,
            skipFiles = skip_files,
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Node: launch current file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = skip_files,
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**",
            },
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Node: attach to process (--inspect)",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = skip_files,
          },
        }
      end
    end,
  },
}
