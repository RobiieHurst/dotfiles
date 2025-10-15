return {
	"norcalli/nvim-colorizer.lua",
	config = true,
	lazy = true,
	cmd = {
		"ColorizerToggle",
		"ColorizerAttachToBuffer",
		"ColorizerReloadAllBuffers",
		"ColorizerDetachFromBuffer",
	},
	opts = {
		"css",
		"javascript",
		"html",
		"json",
		"sql",
		"vue",
	},
	ft = { "css", "javascript", "html", "json", "sql", "vue" },
}
