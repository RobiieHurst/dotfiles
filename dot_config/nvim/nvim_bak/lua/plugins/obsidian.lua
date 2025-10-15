return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "daily",
        path = "~/Documents/rob/daily-vault/",
      },
      {
        name = "script-sight",
        path = "~/Documents/rob/script-sight-vault/",
      },
    },
  },
}
