return {
  "olimorris/codecompanion.nvim",
  version = "^19.0.0",
  cmd = {
    "CodeCompanion",
    "CodeCompanionActions",
    "CodeCompanionChat",
    "CodeCompanionCLI",
    "CodeCompanionCmd",
  },
  keys = {
    { "<C-a>", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion actions" },
    {
      "<localleader>a",
      "<cmd>CodeCompanionChat Toggle<cr>",
      mode = { "n", "v" },
      desc = "Toggle CodeCompanion chat",
    },
    { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add selection to CodeCompanion" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "folke/snacks.nvim",
  },
  opts = {
    interactions = {
      chat = {
        adapter = "opencode",
      },
      cli = {
        agent = "opencode",
        agents = {
          opencode = {
            cmd = "opencode",
            args = {},
            description = "OpenCode CLI",
            provider = "terminal",
          },
        },
      },
    },
    display = {
      action_palette = {
        provider = "snacks",
      },
      chat = {
        window = {
          position = "right",
          width = 0.45,
        },
      },
    },
  },
  init = function()
    vim.cmd([[cab cc CodeCompanion]])
  end,
}
