return {
  "mfussenegger/nvim-lint",
  opts = {
    linters = {
      -- nvim-lint pipes buffers to markdownlint-cli2 via stdin, so it never
      -- discovers config files on its own — point it at the global one.
      ["markdownlint-cli2"] = {
        args = { "--config", vim.fn.expand("~/.markdownlint.yaml"), "-" },
      },
    },
  },
}
