return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-vitest",
    },
    keys = {
      -- Debug runs disable vitest's 5s test/hook timeouts, so sitting at a
      -- breakpoint doesn't kill the test ("Test timed out in 5000ms" /
      -- STACK_TRACE_ERROR). Normal runs keep the timeouts.
      -- <leader>td overrides LazyVim's mapping to add this.
      {
        "<leader>td",
        function()
          require("neotest").run.run({
            strategy = "dap",
            extra_args = { "--testTimeout=0", "--hookTimeout=0" },
          })
        end,
        desc = "Debug Nearest (Neotest)",
      },
      {
        "<leader>tD",
        function()
          require("neotest").run.run({
            vim.fn.expand("%"),
            strategy = "dap",
            extra_args = { "--testTimeout=0", "--hookTimeout=0" },
          })
        end,
        desc = "Debug File (Neotest)",
      },
      {
        "<leader>tA",
        function()
          require("neotest").run.run({
            vim.uv.cwd(),
            strategy = "dap",
            extra_args = { "--testTimeout=0", "--hookTimeout=0" },
          })
        end,
        desc = "Debug All Test Files (Neotest)",
      },
    },
    opts = {
      adapters = {
        ["neotest-vitest"] = {
          is_test_file = function(file_path)
            return file_path:match("__tests__") ~= nil
              or file_path:match("%.test%.[cm]?jsx?$") ~= nil
              or file_path:match("%.spec%.[cm]?jsx?$") ~= nil
              or file_path:match("%.test%.[cm]?tsx?$") ~= nil
              or file_path:match("%.spec%.[cm]?tsx?$") ~= nil
          end,
        },
      },
    },
  },
}
