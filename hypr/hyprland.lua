hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "0.5",
})

-- require(monitors.lua) -- display setting generated config

local Terminal = "kitty"
local Explorer = "thunar"
local Launcher = "rofi"
local Editor = "nvim"
local Browser = "firefox"

hl.env("XCURSOR_SIZE", "10")
hl.env("HYPRCURSOR_SIZE", "10")

local Mod = "SUPER"

function bind_exec(bind, exec)
	hl.bind(bind, hl.dsp.exec_cmd(exec))
end

function bind_exec_super(bind, exec)
	bind_exec(Mod .. " + " .. bind, exec)
end

local closeWindow = hl.bind(Mod .. " + Q", hl.dsp.window.close())

bind_exec_super("Return", Terminal)
bind_exec_super("E", Explorer)
bind_exec_super("B", Browser)
bind_exec_super("Super_L", "pkill rofi || rofi -show drun -modi drun,filebrowser,run,window")
