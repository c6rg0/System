-- hl.monitor({ output = "", mode = "1920x1080", position = "0x0", scale = 1 })

-- eDP-1 (laptop screen)
hl.monitor({
	output = "eDP-1",
	mode = "1920x1080",
	position = "0x0",
	bitdepth = 10,
	disabled = false,
	scale = 1,
})

hl.monitor({
	output = "HDMI-A3",
	mode = "1920x1080@180.00Hz",
	vrr = 0,
	position = "0x0", --"-792x-2160",
	bitdepth = 10,
	disabled = true,
	scale = 1,
})
