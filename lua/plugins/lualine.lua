return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			theme = function()
				return vim.o.background == "light" and "noita-light" or "noita"
			end,
		},
	},
}
