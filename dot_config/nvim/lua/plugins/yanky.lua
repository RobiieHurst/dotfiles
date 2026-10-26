return {
  "gbprod/yanky.nvim",
  event = "LazyFile",
  opts = {
    ring = {
      history_length = 100,
      storage = "shada",
      sync_with_numbered_registers = true,
    },
    system_clipboard = {
      sync_with_ring = true,
    },
    highlight = {
      on_put = true,
      on_yank = true,
      timer = 200,
    },
    preserve_cursor_position = {
      enabled = true,
    },
  },
  keys = {
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put After" },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put Before" },
    { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put After Selection" },
    { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put Before Selection" },
    -- Cycle through yank history right after a put
    { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle Yank History Forward" },
    { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle Yank History Backward" },
    {
      "<leader>y",
      function()
        Snacks.picker.yanky()
      end,
      desc = "Yank History",
    },
  },
}
