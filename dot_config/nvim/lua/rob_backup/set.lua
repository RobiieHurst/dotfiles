vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

if vim.bo.buftype == "" then
	vim.opt.tabstop = 2
	vim.opt.softtabstop = 2
	vim.opt.shiftwidth = 2
	vim.opt.expandtab = true

	vim.opt.smartindent = true

	vim.opt.wrap = false

	vim.opt.colorcolumn = "80"
end

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

-- Configure clipboard to use system clipboard
vim.opt.clipboard = "unnamedplus"

-- Set up system clipboard integration
-- vim.g.clipboard = {
-- 	name = "macOS-clipboard",
-- 	copy = {
-- 		["+"] = "pbcopy",
-- 		["*"] = "pbcopy",
-- 	},
-- 	paste = {
-- 		["+"] = "pbpaste",
-- 		["*"] = "pbpaste",
-- 	},
-- 	cache_enabled = 0,
-- }

-- Enable the option to require a Prettier config file
-- If no prettier config file is found, the formatter will not be used
vim.g.lazyvim_prettier_needs_config = false

-- Set conceallevel for Obsidian.nvim
-- Level 2 hides the markup and shows only the text/replacement character
vim.opt.conceallevel = 2
