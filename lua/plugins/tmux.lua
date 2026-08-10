return {
	"christoomey/vim-tmux-navigator",
	lazy = false,
	config = function()
		local directions = {
			["<C-h>"] = "TmuxNavigateLeft",
			["<C-j>"] = "TmuxNavigateDown",
			["<C-k>"] = "TmuxNavigateUp",
			["<C-l>"] = "TmuxNavigateRight",
		}

		for key, command in pairs(directions) do
			vim.keymap.set("i", key, "<Cmd>" .. command .. "<CR>", { silent = true })
		end
	end,
}
