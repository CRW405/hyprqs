-- Central style loader: reads style/style.json (also used by qs/theme/Palette.qml
-- and hypr/rofi/colors.rasi) into a plain Lua table.
-- Colors are bare 6-digit hex strings (no "#", no alpha) - format per call site, e.g.
--   col = { active_border = "rgba(" .. Style.colors.accent .. "ee)" }

-- resolved via debug info, not require(), to avoid hyprland.lua's custom require() shim
local script_dir = debug.getinfo(1, "S").source:match("^@(.*/)")
local json = dofile(script_dir .. "lib/json.lua")

local file = assert(io.open(script_dir .. "style.json", "r"))
local contents = file:read("*a")
file:close()

return json.decode(contents)
