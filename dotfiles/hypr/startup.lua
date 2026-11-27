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
hl.env("QSG_RHI_BACKEND", "opengl")

hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")


hl.plugin.load("/run/current-system/sw/lib/libhyprbars.so")
-- I need to compile this plugin against the new hyprland version
-- hl.plugin.load("/run/current-system/sw/lib/libhyprview.so")

hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd --all")
  --[[
	hl.exec_cmd("awww-daemon")
  hl.exec_cmd("qs -p ~/System/dotfiles/quickshell -d")
	hl.exec_cmd("waybar")
	hl.exec_cmd("otd-daemon")
  --]]
end)
