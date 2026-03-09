return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	config = function()
		local focus_key = "<C-]>"
		local resume_key = "<leader>cr"
		local buffer_key = "<leader>cb"
		local select_key = "<leader>cc"

		vim.keymap.set({ "n", "x" }, focus_key, "<cmd>ClaudeCodeFocus<cr>", { desc = "Claude Focus" })
		vim.keymap.set({ "n", "x" }, resume_key, "<cmd>ClaudeCode --resume<cr>", { desc = "Claude Resume" })
		vim.keymap.set("n", select_key, "V<cmd>ClaudeCodeSend<cr>", { desc = "Claude Send Line" })
		vim.keymap.set("v", select_key, "<cmd>ClaudeCodeSend<cr>", { desc = "Claude Select" })

		require("claudecode").setup({
			terminal_cmd = "cd ~; claude --dangerously-skip-permissions",
			terminal = {
				---@module "snacks"
				---@type snacks.win.Config|{}
				snacks_win_opts = {
					keys = {
						claude_hide = {
							focus_key,
							function(self)
								self:hide()
							end,
							mode = "t",
							desc = "Hide",
						},
					},
				},
			},
		})
	end,
}
