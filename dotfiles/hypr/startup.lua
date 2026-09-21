hl.env("TERMINAL", "kitty")
hl.env("HYPRCURSOR_THEME", "macOS")
hl.env("HYPRCURSOR_SIZE", "32")
hl.env("LANGUAGE", "en_GB")
hl.env("LANG", "en_GB.UTF-8")

hl.env("AQ_DRM_DEVICES", "/dev/dri/card0")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GL_GSYNC_ALLOWED", "0")
hl.env("__GL_VRR_ALLOWED", "0")

hl.on("hyprland.start", function()
  -- Manually loading plugins
	hl.exec_cmd("hyprctl plugin load /run/current-system/sw/lib/libhyprbars.so")
	hl.exec_cmd("hyprctl plugin load /run/current-system/sw/lib/libhyprview.so")

	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("qs -p ~/System/dotfiles/quickshell")
	hl.exec_cmd("waybar")
	hl.exec_cmd("otd-daemon")
end)
