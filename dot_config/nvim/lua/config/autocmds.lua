-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Custom augroups
local robGroup = augroup("robGroup", {})
local yank_group = augroup("HighlightYank", {})

-- Reload module function for development
function R(name)
	require("plenary.reload").reload_module(name)
end

-- Custom filetype support
vim.filetype.add({
  extension = {
    templ = "templ",
  },
  filename = {
    [".env"] = "config",
    [".env.local"] = "config",
    [".env.development"] = "config",
    [".env.production"] = "config",
    [".env.test"] = "config",
  },
  pattern = {
    ["%.env%..*"] = "config", -- Matches .env.anything
  },
})

-- Highlight yanked text
autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

-- Remove trailing whitespace on save
autocmd({ "BufWritePre" }, {
	group = robGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

-- LSP on_attach keybinds
autocmd("LspAttach", {
  group = robGroup,
  callback = function(e)
    -- Check if this is a .env file and disable LSP if so
    local filename = vim.api.nvim_buf_get_name(e.buf)
    if filename:match("%.env") or filename:match("%.env%.") then
      -- Detach LSP from .env files
      vim.schedule(function()
        local clients = vim.lsp.get_clients({ bufnr = e.buf })
        for _, client in ipairs(clients) do
          vim.lsp.buf_detach_client(e.buf, client.id)
        end
      end)
      return
    end
    
    local opts = { buffer = e.buf }
    vim.keymap.set("n", "gd", function()
      vim.lsp.buf.definition()
    end, opts)
    vim.keymap.set("n", "K", function()
      vim.lsp.buf.hover()
    end, opts)
    vim.keymap.set("n", "<leader>vws", function()
      vim.lsp.buf.workspace_symbol()
    end, opts)
    vim.keymap.set("n", "<leader>vd", function()
      vim.diagnostic.open_float()
    end, opts)
    vim.keymap.set("n", "<leader>vca", function()
      vim.lsp.buf.code_action()
    end, opts)
    vim.keymap.set("n", "<leader>vrr", function()
      vim.lsp.buf.references()
    end, opts)
    vim.keymap.set("n", "<leader>vrn", function()
      vim.lsp.buf.rename()
    end, opts)
    vim.keymap.set("i", "<C-h>", function()
      vim.lsp.buf.signature_help()
    end, opts)
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.goto_next()
    end, opts)
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.goto_prev()
    end, opts)
  end,
})

-- Prevent LSP from attaching to .env files in the first place
autocmd("FileType", {
  group = robGroup,
  pattern = { "config", "dosini" }, -- Common filetypes for .env files
  callback = function(e)
    local filename = vim.api.nvim_buf_get_name(e.buf)
    if filename:match("%.env") or filename:match("%.env%.") then
      -- Disable LSP for .env files
      vim.bo[e.buf].filetype = "text" -- Change to plain text to avoid LSP
      -- Also disable any existing LSP clients
      local clients = vim.lsp.get_clients({ bufnr = e.buf })
      for _, client in ipairs(clients) do
        vim.lsp.buf_detach_client(e.buf, client.id)
      end
    end
  end,
})

-- Netrw settings
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25



