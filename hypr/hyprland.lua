hl.on("hyprland.start", function()
	hl.exec_cmd(waybar)
	hl.exec_cmd(hyprpaper)
end)

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1.0",
})

-- require(monitors.lua) -- display setting generated config

local Terminal = "kitty"
local Explorer = "thunar"
local Launcher = "rofi"
local Editor = "nvim"
local Browser = "firefox"

hl.env("XCURSOR_SIZE", "20")
hl.env("HYPRCURSOR_SIZE", "20")

local Mod = "SUPER"

function bind_exec(bind, exec)
	hl.bind(bind, hl.dsp.exec_cmd(exec))
end

function bind_exec_super(bind, exec)
	bind_exec(Mod .. " + " .. bind, exec)
end

local closeWindow = hl.bind(Mod .. " + Q", hl.dsp.window.close())
hl.bind(Mod .. " + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(Mod .. " + X", hl.dsp.layout("togglesplit"))

bind_exec_super("Return", Terminal)
bind_exec_super("E", Explorer)
bind_exec_super("B", Browser)
bind_exec_super("Super_L", "pkill rofi || rofi -show drun -modi drun,filebrowser,run,window")

hl.bind(Mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(Mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(Mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(Mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(Mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(Mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(Mod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(Mod .. " + J", hl.dsp.focus({ direction = "down" }))

hl.bind(Mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(Mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

for i = 1, 10 do
	local key = i % 10
	hl.bind(Mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(Mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(Mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(Mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

local suppressMaximizeRule = hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

hl.config({
	general = {
		gaps_in = 0,
		gaps_out = 0,
		border_size = 1,
		col = {
			-- active_border = { colors = { "rgba(ff0000ee)", "rgba(0000ffee)", angle = 45 } },
			-- inactive_border = "rgba(00ff00ee)",
		},
		resize_on_border = true,
		allow_tearing = true,
		layout = "dwindle", -- scrolling -- look into custom layouts
	},
	decoration = {
		rounding = 0,
		rounding_power = 0,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = {
			enabled = false,
			range = 1,
			render_power = 1,
			color = 0x0000ffee,
		},
		blur = {
			enabled = false,
			size = 1,
			passes = 1,
			vibrancy = 1.0,
		},
	},
	animations = {
		enabled = false,
	},
})

hl.config({
	dwindle = {
		preserve_split = true,
	},
	scrolling = {
		fullscreen_on_one_column = false,
	},
})

hl.config({
	misc = {
		force_default_wallpaper = 1,
		disable_hyprland_logo = true,
	},
})

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = false,
		},
	},
})

-- hl.gesture({
--     fingers = 3,
--     direction = "horizontal",
--     action = "workspace"
-- })

-- hl.device({
--     name        = "epic-mouse-v1",
--     sensitivity = -0.5,
-- })

-- hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
-- hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
-- hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
-- hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
-- hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
-- hl.curve("easy", { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })
-- hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
-- hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
-- hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
-- hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
-- hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
-- hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
-- hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
-- hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
-- hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
-- hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
-- hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
-- hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
-- hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
-- hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
-- hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
-- hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
-- hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })
