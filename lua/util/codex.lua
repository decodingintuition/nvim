local M = {}

local terminal = nil

local cmd = "codex --dangerously-bypass-approvals-and-sandbox --model gpt-5.6-sol -c model_reasoning_effort='xhigh'"
M.config = {
	cmd = cmd,
	resume_cmd = cmd .. " resume",
	split_side = "right",
	split_width = 0.3,
	hide_key = "<C-]><C-]>",
}

local function is_open()
	return terminal ~= nil and terminal:buf_valid()
end

local function open(cmd)
	local term = Snacks.terminal.open(cmd, {
		start_insert = true,
		auto_insert = true,
		auto_close = false,
		win = {
			position = M.config.split_side,
			width = M.config.split_width,
			height = 0,
			relative = "editor",
			keys = {
				codex_hide = {
					M.config.hide_key,
					function(self)
						self:hide()
					end,
					mode = "t",
					desc = "Hide Codex",
				},
			},
		},
	})
	if not (term and term:buf_valid()) then
		vim.notify("Failed to open Codex terminal", vim.log.levels.ERROR)
		return nil
	end
	term:on("TermClose", function()
		terminal = nil
		vim.schedule(function()
			term:close({ buf = true })
			vim.cmd.checktime()
		end)
	end, { buf = true })
	term:on("BufWipeout", function()
		terminal = nil
	end, { buf = true })
	terminal = term
	return term
end

local function focus()
	if not terminal:win_valid() then
		terminal:toggle()
	end
	if terminal.win and vim.api.nvim_win_is_valid(terminal.win) then
		vim.api.nvim_set_current_win(terminal.win)
		vim.cmd.startinsert()
	end
end

function M.focus_toggle()
	if is_open() and terminal:win_valid() and terminal.win == vim.api.nvim_get_current_win() then
		terminal:hide()
	elseif is_open() then
		focus()
	else
		open(M.config.cmd)
	end
end

function M.resume()
	if is_open() then
		focus()
	else
		open(M.config.resume_cmd)
	end
end

local function send_text(text)
	if is_open() then
		vim.api.nvim_chan_send(vim.bo[terminal.buf].channel, text)
		focus()
	else
		local term = open(M.config.cmd)
		if not term then
			return
		end
		-- give the codex TUI a moment to start before feeding it input
		vim.defer_fn(function()
			if is_open() then
				vim.api.nvim_chan_send(vim.bo[terminal.buf].channel, text)
			end
		end, 700)
	end
end

function M.send_selection()
	local path = vim.fn.expand("%:.")
	if path == "" then
		vim.notify("No file for current buffer", vim.log.levels.WARN)
		return
	end
	local first = vim.fn.line("v")
	local last = vim.fn.line(".")
	if first > last then
		first, last = last, first
	end
	if vim.fn.mode():match("[vV\22]") then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
	end
	local ref = first == last and (path .. ":" .. first) or (path .. ":" .. first .. "-" .. last)
	send_text(ref .. " ")
end

return M
