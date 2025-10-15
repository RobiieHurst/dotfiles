-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable cursor styling in terminal
vim.opt.guicursor = ""

-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Tab and indentation settings (for most files)
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Line wrapping and column guide
vim.opt.wrap = false
vim.opt.colorcolumn = "80"

-- Disable swap and backup files, enable persistent undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Search settings
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Colors and UI
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Update time for faster completion
vim.opt.updatetime = 50

-- System clipboard integration
vim.opt.clipboard = "unnamedplus"

-- Enable the option to require a Prettier config file
vim.g.lazyvim_prettier_needs_config = false

-- Concealment level for markdown/obsidian
vim.opt.conceallevel = 2

-- Encoding settings
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = { "utf-8" }

-- Spell checking
vim.opt.spelllang = "en_us"
vim.opt.spell = true

-- Treesitter stability settings
vim.g.treesitter_highlighter_enable = true
vim.g.treesitter_incremental_selection_enable = true

-- Add redraw settings for better stability
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000