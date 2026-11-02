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

hl.on("hyprland.start", function()
  -- Manually loading plugins
	hl.exec_raw("dbus-update-activation-environment --systemd --all")

	hl.exec_raw("hyprctl plugin load /run/current-system/sw/lib/libhyprbars.so")
	hl.exec_raw("hyprctl plugin load /run/current-system/sw/lib/libhyprview.so")

	hl.exec_raw("awww-daemon")
	hl.exec_raw("qs -p ~/System/dotfiles/quickshell --log-rules $'quickshell.dbus.properties.warning=false;quickshell.dbus.dbusmenu.warning=false;quickshell.service.notifications.warning=false;quickshell.service.sni.host.warning=false;qt.qpa.wayland.textinput.warning=false' -d")
	-- hl.exec_raw("waybar")
	hl.exec_raw("otd-daemon")
end)
