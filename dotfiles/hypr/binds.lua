-- Keybindings
-- https://wiki.hypr.land/Configuring/Basics/Binds/

local SUPER = "SUPER"
local SUPER_SHIFT = "SUPER + SHIFT"

-- Brightness
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("quickshell ipc -p ~/System/dotfiles/quickshell call osd brightnessUp"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("quickshell ipc -p ~/System/dotfiles/quickshell call osd brightnessDown"),
	{ repeating = true, locked = true }
)
hl.bind(
  "SHIFT + XF86MonBrightnessUp",
	hl.dsp.exec_cmd("quickshell ipc -p ~/System/dotfiles/quickshell call osd brightnessUpFine"),
	{ repeating = true, locked = true }
)
hl.bind(
	"SHIFT + XF86MonBrightnessDown",
	hl.dsp.exec_cmd("quickshell ipc -p ~/System/dotfiles/quickshell call osd brightnessDownFine"),
	{ repeating = true, locked = true }
)

-- Volume
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("quickshell ipc -p ~/System/dotfiles/quickshell call osd volumeUp"),
	{ repeating = true, locked = true }
)
hl.bind(
  "SUPER + SHIFT + equal",
	hl.dsp.exec_cmd("quickshell ipc -p ~/System/dotfiles/quickshell call osd volumeUp"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("quickshell ipc -p ~/System/dotfiles/quickshell call osd volumeDown"),
	{ repeating = true, locked = true }
)
hl.bind(
	"SUPER + SHIFT + minus",
	hl.dsp.exec_cmd("quickshell ipc -p ~/System/dotfiles/quickshell call osd volumeDown"),
	{ repeating = true, locked = true }
)
hl.bind(
	"SHIFT + XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("quickshell ipc -p ~/System/dotfiles/quickshell call osd volumeUpFine"),
	{ repeating = true, locked = true }
)
hl.bind(
	"SHIFT + XF86AudioLowerVolume",
	hl.dsp.exec_cmd("quickshell ipc -p ~/System/dotfiles/quickshell call osd volumeDownFine"),
	{ repeating = true, locked = true }
)

-- Mute / Power / Media
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("quickshell ipc -p ~/System/dotfiles/quickshell call osd volumeMute"),
	{ locked = true }
)
hl.bind(
	"SUPER + M",
	hl.dsp.exec_cmd("quickshell ipc -p ~/System/dotfiles/quickshell call osd volumeMute"),
	{ locked = true }
)
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("pkill wleave || wleave -m 500 -c 50 -f"), { locked = true })
hl.bind("SHIFT + XF86PowerOff", hl.dsp.exec_cmd("systemctl suspend"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("SUPER + Return", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("SUPER + numbersign", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("SUPER + Shift_R", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioMedia", hl.dsp.exec_cmd("~/.config/hypr/Scripts/powermode.sh"))

local MAX_ZOOM = 10
local MIN_ZOOM = 1
local ZOOM_TOGGLE_FACTOR = 1.5
local function zoom(offset)
	local current = hl.get_config("cursor.zoom_factor")
	if offset ~= nil then
		current = current + offset
	elseif current ~= MIN_ZOOM then
		current = MIN_ZOOM
	else
		current = ZOOM_TOGGLE_FACTOR
	end
	current = math.max(MIN_ZOOM, math.min(MAX_ZOOM, current))
	hl.config({ cursor = { zoom_factor = current } })
end

--[[
hl.bind("SUPER + mouse_down", function()
	zoom(-0.5)
end)
hl.bind("SUPER + mouse_up", function()
	zoom(0.5)
end)
--]]

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace", disable_inhibit = true })
hl.gesture({
	fingers = 3,
	direction = "vertical",
	action = function()
		hl.exec_cmd("quickshell ipc -p ~/System/dotfiles/quickshell/ call expose toggle")
	end,
	disable_inhibit = true,
})

hl.gesture({ fingers = 3, direction = "pinchin", action = "cursorZoom", zoom_level = 1, scale = 1, mode = "live" })
hl.gesture({ fingers = 3, direction = "pinchout", action = "cursorZoom" })

hl.gesture({
	fingers = 4,
	direction = "right",
	action = function()
		hl.exec_cmd("playerctl previous")
	end,
})
hl.gesture({
	fingers = 4,
	direction = "left",
	action = function()
		hl.exec_cmd("playerctl next")
	end,
})

local volume_gesture = function(change)
	hl.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ " .. math.abs(change) .. "%" .. (change < 0 and "-" or "+"))
	hl.exec_cmd("quickshell ipc -p ~/System/dotfiles/quickshell call osd volumeRefresh")
end
hl.gesture({
	fingers = 4,
	direction = "vertical",
	action = {
		start = function(e)
			volume_gesture(-0.1 * e.delta.y)
		end,
		update = function(e)
			volume_gesture(-0.1 * e.delta.y)
		end,
	},
	disable_inhibit = true,
})

hl.bind(SUPER_SHIFT .. " + C", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind(SUPER .. " + A", hl.dsp.exec_cmd("scrcpy -w -S -K"))
-- Region screenshot overlay. Bound as a global shortcut so it dispatches
-- straight into the running quickshell instance instead of spawning `qs -p`
-- (see quickshell/screenshot/):
--   quickshell:region      -> save to ~/Pictures/Screenshots and copy
--   quickshell:regionTemp  -> copy to clipboard only
--   quickshell:regionEdit  -> open satty to annotate before saving
hl.bind(SUPER_SHIFT .. " + S", hl.dsp.global("quickshell:region"))
hl.bind("Print", hl.dsp.global("quickshell:regionTemp"), { locked = true })

-- Pass F2 to OBS (push-to-talk / global shortcut)
hl.bind("SHIFT + F2", hl.dsp.pass({ window = "class:^(com\\.obsproject\\.Studio)$" }), { non_consuming = true })

-- Expose / overview
hl.bind(SUPER .. " + Tab", hl.dsp.exec_cmd("quickshell ipc -p ~/System/dotfiles/quickshell/ call expose toggle"))

--hl.bind("ALT + Tab",hl.dsp.exec_cmd("snappy-switcher next --mod alt"),{bypass=true,repeating=true})
--hl.bind("ALT + SHIFT + Tab",hl.dsp.exec_cmd("snappy-switcher prev --mod alt"),{bypass=true,repeating=true})

-- App launcher
hl.bind(SUPER .. " + space", hl.dsp.global("quickshell:Spotlight"))
-- hl.bind(SUPER .. " + space", hl.dsp.exec_cmd("rofi -show drun"))

-- Night mode
hl.bind(SUPER .. " + M", hl.dsp.exec_cmd("pkill hyprsunset || hyprsunset -t 4000"))
hl.bind(SUPER_SHIFT .. " + M", hl.dsp.exec_cmd("pkill hyprsunset || hyprsunset -t 3000"))

-- Apps
hl.bind(SUPER .. " + B", hl.dsp.exec_cmd("firefox"))
hl.bind(SUPER_SHIFT .. " + W", hl.dsp.exec_cmd("firefox", { float = true }))
hl.bind(SUPER .. " + O", hl.dsp.exec_cmd("osu-lazer"))
hl.bind(SUPER .. " + I", hl.dsp.exec_cmd("systemsettings"))
-- hl.bind(SUPER_SHIFT .. " + I", hl.dsp.exec_cmd("invertactivewindow"))
hl.bind(SUPER .. " + Q", hl.dsp.exec_cmd("kitty"))
hl.bind(SUPER_SHIFT .. " + L", hl.dsp.exec_cmd("hyprlock"))

hl.bind(SUPER_SHIFT .. " + L", function()
	hl.timer(function()
		hl.dispatch(hl.dsp.dpms({ action = "disable" }))
	end, { timeout = 1000, type = "oneshot" })
end)

-----------------------------
---- SPECIAL WORKSPACES  ----
-----------------------------

hl.bind(SUPER .. " + D", hl.dsp.workspace.toggle_special("discord"))
hl.bind(SUPER_SHIFT .. " + D", hl.dsp.window.move({ workspace = "special:discord" }))
hl.bind(SUPER .. " + S", hl.dsp.exec_cmd("fooyin"))

hl.bind(SUPER .. " + C", hl.dsp.workspace.toggle_special("code"))
hl.bind(SUPER .. " + X", hl.dsp.workspace.toggle_special("obs"))
hl.bind(SUPER .. " + N", hl.dsp.workspace.toggle_special("note"))
hl.bind(SUPER .. " + G", hl.dsp.workspace.toggle_special("game"))
hl.bind(SUPER_SHIFT .. " + G", hl.dsp.window.move({ workspace = "special:game" }))
hl.bind(SUPER_SHIFT .. " + X", hl.dsp.workspace.toggle_special("windows"), { bypass = true, submap_universal = true })
hl.gesture({
	fingers = 4,
	direction = "down",
	mods = "SUPER",
	action = "special",
	workspace_name = "windows",
	disable_inhibit = true,
})

-----------------------------
--------  RELOAD  -----------
-----------------------------

hl.bind("CTRL + SHIFT + delete", function()
	hl.dispatch(hl.dsp.exec_cmd("hyprctl reload"))
	hl.dispatch(hl.dsp.exec_cmd("pkill wofi"))
end)

-----------------------------
-----  WINDOW MANAGEMENT  ---
-----------------------------

hl.bind(SUPER .. " + K", hl.dsp.window.close())
hl.bind(SUPER .. " + escape", hl.dsp.window.float({ action = "toggle" }))
hl.bind(SUPER .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(SUPER_SHIFT .. " + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 3, action = "toggle" }))
hl.bind(SUPER .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(SUPER_SHIFT .. " + P", hl.dsp.window.pin())

-- Focus
hl.bind(SUPER .. " + up", function()
	hl.dispatch(hl.dsp.focus({ direction = "u" }))
	hl.dispatch(hl.dsp.window.bring_to_top())
end)
hl.bind(SUPER .. " + down", function()
	hl.dispatch(hl.dsp.focus({ direction = "d" }))
	hl.dispatch(hl.dsp.window.bring_to_top())
end)
hl.bind(SUPER .. " + right", function()
	hl.dispatch(hl.dsp.focus({ direction = "r" }))
	hl.dispatch(hl.dsp.window.bring_to_top())
end)
hl.bind(SUPER .. " + left", function()
	hl.dispatch(hl.dsp.focus({ direction = "l" }))
	hl.dispatch(hl.dsp.window.bring_to_top())
end)

-- Workspace navigation
hl.bind(SUPER .. " + 1", hl.dsp.focus({ workspace = "1" }))
hl.bind(SUPER .. " + 2", hl.dsp.focus({ workspace = "2" }))
hl.bind(SUPER .. " + 3", hl.dsp.focus({ workspace = "3" }))
hl.bind(SUPER .. " + 4", hl.dsp.focus({ workspace = "4" }))
hl.bind(SUPER .. " + 5", hl.dsp.focus({ workspace = "5" }))
hl.bind(SUPER .. " + 6", hl.dsp.focus({ workspace = "6" }))
hl.bind(SUPER .. " + 7", hl.dsp.focus({ workspace = "7" }))
hl.bind(SUPER .. " + 8", hl.dsp.focus({ workspace = "8" }))
hl.bind(SUPER .. " + 9", hl.dsp.focus({ workspace = "9" }))
hl.bind(SUPER .. " + 0", hl.dsp.focus({ workspace = "10" }))

hl.bind(SUPER_SHIFT .. " + 1", hl.dsp.window.move({ workspace = "1", follow = false }))
hl.bind(SUPER_SHIFT .. " + 2", hl.dsp.window.move({ workspace = "2", follow = false }))
hl.bind(SUPER_SHIFT .. " + 3", hl.dsp.window.move({ workspace = "3", follow = false }))
hl.bind(SUPER_SHIFT .. " + 4", hl.dsp.window.move({ workspace = "4", follow = false }))
hl.bind(SUPER_SHIFT .. " + 5", hl.dsp.window.move({ workspace = "5", follow = false }))
hl.bind(SUPER_SHIFT .. " + 6", hl.dsp.window.move({ workspace = "6", follow = false }))
hl.bind(SUPER_SHIFT .. " + 7", hl.dsp.window.move({ workspace = "7", follow = false }))
hl.bind(SUPER_SHIFT .. " + 8", hl.dsp.window.move({ workspace = "8", follow = false }))
hl.bind(SUPER_SHIFT .. " + 9", hl.dsp.window.move({ workspace = "9", follow = false }))
hl.bind(SUPER_SHIFT .. " + 0", hl.dsp.window.move({ workspace = "10", follow = false }))

-- Move window to empty workspace with SUPER+SHIFT+RMB
hl.bind(SUPER_SHIFT .. " + mouse:273", hl.dsp.window.move({ workspace = "empty" }))

-- Move / resize with mouse
hl.bind(SUPER .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(SUPER .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Resize with keyboard
hl.bind(SUPER_SHIFT .. " + right", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
hl.bind(SUPER_SHIFT .. " + left", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
hl.bind(SUPER_SHIFT .. " + up", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
hl.bind(SUPER_SHIFT .. " + down", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))
