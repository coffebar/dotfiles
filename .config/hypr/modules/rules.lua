hl.window_rule({ name = "ws-firefox", match = { class = "firefox" }, workspace = "1 silent" })
hl.window_rule({ name = "ws-telegram", match = { class = "org.telegram.desktop" }, workspace = "2 silent" })
hl.window_rule({ name = "ws-phpstorm", match = { class = "jetbrains-phpstorm" }, workspace = "3 silent" })
hl.window_rule({ name = "ws-chrome-upper", match = { class = "Google-chrome" }, workspace = "4 silent" })
hl.window_rule({ name = "ws-chrome-lower", match = { class = "google-chrome" }, workspace = "4 silent" })
hl.window_rule({ name = "ws-edge", match = { class = "Microsoft-edge" }, workspace = "5 silent" })
hl.window_rule({ name = "ws-thunderbird", match = { class = "org.mozilla.Thunderbird" }, workspace = "6 silent" })
hl.window_rule({ name = "ws-keepass", match = { class = "org.keepassxc.KeePassXC" }, workspace = "9 silent" })
hl.window_rule({ name = "ws10-class", match = { class = "workspace10" }, workspace = "10 silent" })

hl.window_rule({ name = "wp-3", match = { class = "^(wp-3)$" }, workspace = "3 silent" })
hl.window_rule({ name = "wp-4", match = { class = "^(wp-4)$" }, workspace = "4 silent" })
hl.window_rule({ name = "wp-5", match = { class = "^(wp-5)$" }, workspace = "5 silent" })
hl.window_rule({ name = "wp-6", match = { class = "^(wp-6)$" }, workspace = "6 silent" })
hl.window_rule({ name = "wp-7", match = { class = "^(wp-7)$" }, workspace = "7 silent" })
hl.window_rule({ name = "wp-8", match = { class = "^(wp-8)$" }, workspace = "8 silent" })
hl.window_rule({ name = "wp-9", match = { class = "^(wp-9)$" }, workspace = "9 silent" })
hl.window_rule({ name = "ws10-title", match = { title = "^(workspace10)$" }, workspace = "10 silent" })

hl.window_rule({
	name = "ff-pip-float",
	match = { class = "^(firefox)$", title = "^(Picture-in-Picture)$" },
	float = true,
})
hl.window_rule({ name = "ff-pip-pin", match = { class = "^(firefox)$", title = "^(Picture-in-Picture)$" }, pin = true })
hl.window_rule({
	name = "ff-sharing-indicator",
	match = { class = "^(firefox)$", title = "^(Firefox — Sharing Indicator)$" },
	float = true,
})

hl.window_rule({
	name = "telegram-media-fullscreen",
	match = { class = "^(org.telegram.desktop)$", title = "^(Media viewer)$" },
	fullscreen = true,
})

hl.window_rule({ name = "file-roller-float", match = { class = "^(file-roller)$" }, float = true })
hl.window_rule({ name = "file-roller-center", match = { class = "^(file-roller)$" }, center = true })

hl.window_rule({ name = "modal-open", match = { title = "^(Open)$" }, float = true })
hl.window_rule({ name = "modal-choose-files", match = { title = "^(Choose Files)$" }, float = true })
hl.window_rule({ name = "modal-save-as", match = { title = "^(Save As)$" }, float = true })
hl.window_rule({ name = "modal-confirm-replace", match = { title = "^(Confirm to replace files)$" }, float = true })
hl.window_rule({ name = "modal-file-op-progress", match = { title = "^(File Operation Progress)$" }, float = true })
hl.window_rule({
	name = "chrome-open-files",
	match = { class = "^(google-chrome)$", title = "^(Open Files)$" },
	float = true,
})
hl.window_rule({
	name = "chrome-open-file",
	match = { class = "^(google-chrome)$", title = "^(Open File)$" },
	float = true,
})

hl.window_rule({ name = "pavucontrol-center", match = { class = "pavucontrol" }, center = true })
hl.window_rule({ name = "pavucontrol-float", match = { class = "pavucontrol" }, float = true })

hl.window_rule({ name = "idle-inhibit-firefox", match = { class = "firefox" }, idle_inhibit = "fullscreen" })
hl.window_rule({ name = "idle-inhibit-mpv", match = { class = "mpv" }, idle_inhibit = "fullscreen" })

hl.window_rule({
	name = "fix-xwayland-drags",
	match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
	no_focus = true,
})
