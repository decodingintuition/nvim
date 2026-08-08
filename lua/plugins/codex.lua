return {
	"folke/snacks.nvim",
	keys = {
		{
			"<C-]><C-]>",
			function()
				require("util.codex").focus_toggle()
			end,
			desc = "Codex Focus",
			mode = { "n", "x" },
		},
		{
			"<C-]>r",
			function()
				require("util.codex").resume()
			end,
			desc = "Codex Resume",
			mode = "n",
		},
		{
			"<C-]>c",
			function()
				require("util.codex").send_selection()
			end,
			desc = "Codex Send",
			mode = { "n", "x" },
		},
	},
}
