local source = debug.getinfo(1, "S").source:sub(2)
local noita = source:gsub("noita%-light%.lua$", "noita.lua")

assert(loadfile(noita))("light")
