local M = {}

local claude_scratch_dir = vim.fn.stdpath("data") .. "/scratch/claude/"
local claude_session = nil

local function ensure_claude_scratch_dir()
	vim.fn.mkdir(claude_scratch_dir, "p")
end

local function get_claude_scratch_files()
	ensure_claude_scratch_dir()
	local files = vim.fn.globpath(claude_scratch_dir, "*.md", 0, 1)
	local scratches = {}
	for _, file in ipairs(files) do
		local filename = vim.fn.fnamemodify(file, ":t:r")
		local session_name, session_id = filename:match("^(.+)%.([a-f0-9%-]+)$")
		if session_name and session_id then
			table.insert(scratches, { id = session_id, name = session_name, filename = filename })
		end
	end
	return scratches
end

local function get_claude_scratch_path(session_id, session_name)
	return claude_scratch_dir .. session_name .. "." .. session_id .. ".md"
end

local function get_session_name_from_id(session_id)
	local scratches = get_claude_scratch_files()
	for _, scratch in ipairs(scratches) do
		if scratch.id == session_id then
			return scratch.name
		end
	end
	return nil
end

local function open_claude_scratch(session_id)
	claude_session = session_id
	local session_name = get_session_name_from_id(session_id)
	if not session_name then
		vim.notify("Error: Could not find session name for ID: " .. session_id, vim.log.levels.ERROR)
		return
	end
	local filepath = get_claude_scratch_path(session_id, session_name)
	Snacks.scratch.open({ file = filepath, name = "Claude: " .. session_name, ft = "markdown" })
end

local function is_claude_scratch_focused()
	local bufname = vim.api.nvim_buf_get_name(0)
	return bufname:match(vim.pesc(claude_scratch_dir)) ~= nil
end

local function close_claude_if_open()
	local terminal = require("claudecode.terminal")
	local active_bufnr = terminal.get_active_terminal_bufnr()
	if active_bufnr then
		terminal.close()
	end
end

function M.new_claude_scratch()
	close_claude_if_open()

	local session_id = vim.fn.system("uuidgen"):gsub("\n", "")

	local terminal = require("claudecode.terminal")
	terminal.open({}, "--session-id " .. session_id .. " \"Hello, Claude!\"")
	return session_id
end

local function find_session_by_name(scratches, name)
	for _, scratch in ipairs(scratches) do
		if scratch.name == name then
			return scratch
		end
	end
	return nil
end

local function create_new_session(name)
	local session_id = M.new_claude_scratch()
	local filepath = get_claude_scratch_path(session_id, name)
	vim.fn.writefile({}, filepath)
	claude_session = session_id
	open_claude_scratch(session_id)
end

local function delete_session(scratches)
	local session_names = {}
	for _, scratch in ipairs(scratches) do
		table.insert(session_names, scratch.name)
	end

	vim.ui.select(session_names, { prompt = "Delete Session:" }, function(name)
		if not name then return end

		local scratch = find_session_by_name(scratches, name)
		if scratch then
			vim.fn.delete(get_claude_scratch_path(scratch.id, scratch.name))
			vim.notify("Deleted: " .. name)
			if claude_session and claude_session == scratch.id then
				claude_session = nil
			end
		end
	end)
end

local function select_existing_session(scratches, choice)
	local scratch = find_session_by_name(scratches, choice)
	if scratch then
		M.set_claude_scratch(scratch.id, scratch.name)
		open_claude_scratch(scratch.id)
	end
end


function M.set_claude_scratch(session_id, session_name)
	close_claude_if_open()

	claude_session = session_id
	local terminal = require("claudecode.terminal")
	terminal.open({}, "--resume " .. session_id)
end

function M.get_claude_scratch()
	return claude_session
end

function M.toggle()
	if claude_session == nil then
		M.menu()
	else
		if is_claude_scratch_focused() then
			Snacks.scratch.close()
		else
			open_claude_scratch(claude_session)
		end
	end
end

function M.menu()
	local scratches = get_claude_scratch_files()
	local items = vim.list_extend({}, vim.tbl_map(function(s) return s.name end, scratches))
	table.insert(items, "+ Create New")
	table.insert(items, "- Delete")

	vim.ui.select(items, { prompt = "Claude Session:" }, function(choice)
		if not choice then return end

		if choice == "+ Create New" then
			local name = vim.fn.input("Session Name: ")
			if name and name ~= "" then
				create_new_session(name)
			end
		elseif choice == "- Delete" then
			delete_session(scratches)
		else
			select_existing_session(scratches, choice)
		end
	end)
end

return M
