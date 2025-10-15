return {
  "nvim-telescope/telescope.nvim",
  opts = function()
    local actions = require("telescope.actions")
    return {
      defaults = {
        -- Include .env files in searches by overriding default file_ignore_patterns
        file_ignore_patterns = {
          "%.git/",
          "node_modules/",
          "%.DS_Store",
          -- Note: NOT including .env files here so they appear in searches
        },
      },
      pickers = {
        find_files = {
          -- Include hidden files like .env
          hidden = true,
          no_ignore = false,
          file_ignore_patterns = {
            "%.git/",
            "node_modules/",
            "%.DS_Store",
            -- Specifically include .env files
          },
        },
        live_grep = {
          -- Include .env files in grep searches
          additional_args = function()
            return { "--hidden", "--glob", "!.git/*" }
          end,
        },
        grep_string = {
          -- Include .env files in grep searches
          additional_args = function()
            return { "--hidden", "--glob", "!.git/*" }
          end,
        },
      },
    }
  end,
  keys = {
    -- Override LazyVim defaults with custom keybinds
    { "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<C-p>", "<cmd>Telescope git_files<cr>", desc = "Find Git Files" },
    { "<leader>vh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
    {
      "<leader>pws",
      function()
        local word = vim.fn.expand("<cword>")
        require("telescope.builtin").grep_string({ search = word })
      end,
      desc = "Grep current word",
    },
    {
      "<leader>pWs",
      function()
        local word = vim.fn.expand("<cWORD>")
        require("telescope.builtin").grep_string({ search = word })
      end,
      desc = "Grep current WORD",
    },
    {
      "<leader>ps",
      function()
        require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
      end,
      desc = "Grep string",
    },
  },
}