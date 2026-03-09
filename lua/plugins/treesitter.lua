return {
	"nvim-treesitter/nvim-treesitter",
	commit = "b065b591",
	build = ":TSUpdate",
	cmd = { "TSInstall", "TSInstallInfo", "TSUpdate", "TSUninstall" },
	event = { "BufReadPost", "BufNewFile" },
	main = "nvim-treesitter.configs",
	opts = {
		ensure_installed = {
			"astro", "bash", "c", "cpp", "css", "diff", "html",
			"java", "javascript", "json", "lua", "luadoc",
			"markdown", "markdown_inline", "python", "query",
			"regex", "rust", "sql", "toml", "tsx", "typescript",
			"vim", "vimdoc", "yaml",
		},
		highlight = { enable = true },
		indent = { enable = true },
	},
}
