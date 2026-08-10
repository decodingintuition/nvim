local M = {}

local sizes = {}
local tracked = setmetatable({}, { __mode = "k" })

function M.get(key, default)
	return sizes[key] or default
end

function M.set(key, size)
	if type(size) == "number" and size > 0 then
		sizes[key] = size
	end
end

function M.track(win, key, dimension)
	if sizes[key] then
		win.opts[dimension] = sizes[key]
	end

	if tracked[win] then
		return
	end

	tracked[win] = true
	win:on("WinResized", function(self)
		if not self:win_valid() then
			return
		end

		local size = dimension == "width" and vim.api.nvim_win_get_width(self.win)
			or vim.api.nvim_win_get_height(self.win)
		M.set(key, size)
		self.opts[dimension] = size
	end, { win = true })
end

return M
