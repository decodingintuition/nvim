local p = {
	bone     = "#c7c7c7",
	fungus   = "#ee538c",
	mana     = "#6895f3",
	portal   = "#a75cd7",
	ambrosia = "#d5ab34",
	tablet   = "#76c395",
	tele     = "#85c6c6",
	lava     = "#f87d01",
	water    = "#7e9792",
	cloak    = "#543f4e",
	fog      = "#363837",
	mines    = "#111217",
	void     = "#010101",
}

return {
	normal = {
		a = { fg = p.void,  bg = p.portal,     gui = "bold" },
		b = { fg = p.bone,  bg = p.fog },
		c = { fg = p.water, bg = p.mines },
	},
	insert = {
		a = { fg = p.void, bg = p.mana,     gui = "bold" },
	},
	visual = {
		a = { fg = p.void, bg = p.ambrosia, gui = "bold" },
	},
	replace = {
		a = { fg = p.void, bg = p.lava,     gui = "bold" },
	},
	command = {
		a = { fg = p.void, bg = p.fungus,   gui = "bold" },
	},
	terminal = {
		a = { fg = p.void, bg = p.tablet,   gui = "bold" },
	},
	inactive = {
		a = { fg = p.water, bg = p.cloak,  gui = "bold" },
		b = { fg = p.water, bg = p.fog },
		c = { fg = p.cloak, bg = p.mines },
	},
}
