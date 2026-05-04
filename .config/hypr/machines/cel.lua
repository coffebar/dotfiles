-- monitors
hl.monitor({ output = "eDP-1", mode = "1920x1200@60", position = "auto", scale = "1.2" })
hl.monitor({ output = "desc:Dell Inc. DELL P2722HE D0TCBH3", mode = "1920x1080", position = "0x0", scale = "1" })
hl.monitor({ output = "desc:Dell Inc. DELL P2719H 7JJ9QS2", mode = "1920x1080", position = "3520x0", scale = "1" })

-- workspace rules
hl.workspace_rule({ workspace = "1", monitor = "DP-5" })
hl.workspace_rule({ workspace = "2", monitor = "DP-5" })
hl.workspace_rule({ workspace = "3", monitor = "DP-5" })
hl.workspace_rule({ workspace = "7", monitor = "DP-6" })
hl.workspace_rule({ workspace = "8", monitor = "DP-6" })
hl.workspace_rule({ workspace = "9", monitor = "DP-6" })
hl.workspace_rule({ workspace = "4", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "5", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "6", monitor = "eDP-1" })

-- core overrides
hl.config({
	input = {
		kb_layout = "us,ru,ua",
	},
})

-- autostart
hl.on("hyprland.start", function()
	hl.exec_cmd("swaybg -i /usr/share/backgrounds/Fuji_san_by_amaral.png")
	hl.exec_cmd("foot")
	hl.exec_cmd("gnome-keyring-daemon --start --components=pkcs11,secrets,ssh")
	hl.exec_cmd("google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland")
	hl.exec_cmd("datagrip")
	hl.exec_cmd("~/.local/bin/token-vault")
end)

local function move_workspaces(assignments)
	for ws, mon in pairs(assignments) do
		hl.dispatch(hl.dsp.workspace.move({ workspace = ws, monitor = mon }))
	end
end

local function apply_monitor_layout(name)
	if name == "DP-5" then
		hl.monitor({ output = "eDP-1", mode = "1920x1200@60", position = "1920x0", scale = "1.2" })
		move_workspaces({
			[1] = "DP-5",
			[2] = "DP-5",
			[3] = "DP-5",
			[7] = "DP-6",
			[8] = "DP-6",
			[9] = "DP-6",
			[4] = "eDP-1",
			[5] = "eDP-1",
			[6] = "eDP-1",
		})
		hl.exec_cmd("sudo systemctl restart nordlayer")
		hl.dispatch(hl.dsp.focus({ workspace = 4 }))
	elseif name == "DP-8" then
		hl.monitor({ output = "eDP-1", mode = "1920x1200@60", position = "1920x0", scale = "1.2" })
		move_workspaces({
			[1] = "DP-7",
			[2] = "DP-7",
			[3] = "DP-7",
			[7] = "DP-8",
			[8] = "DP-8",
			[9] = "DP-8",
			[4] = "eDP-1",
			[5] = "eDP-1",
			[6] = "eDP-1",
		})
		hl.exec_cmd("sudo systemctl restart nordlayer")
		hl.dispatch(hl.dsp.focus({ workspace = 4 }))
	elseif name == "HDMI-A-1" then
		hl.monitor({ output = "HDMI-A-1", mode = "3840x2160@60", position = "0x0", scale = "1.5" })
		hl.monitor({ output = "eDP-1", mode = "1920x1200@60", position = "0x1441", scale = "1.2" })
		move_workspaces({
			[1] = "HDMI-A-1",
			[2] = "HDMI-A-1",
			[3] = "HDMI-A-1",
			[7] = "HDMI-A-1",
			[8] = "HDMI-A-1",
			[9] = "HDMI-A-1",
			[10] = "HDMI-A-1",
			[4] = "eDP-1",
			[5] = "eDP-1",
			[6] = "eDP-1",
		})
		hl.exec_cmd("sudo systemctl restart nordlayer")
		hl.dispatch(hl.dsp.focus({ workspace = 1 }))
	end
end

local function apply_all_connected()
	for _, mon in ipairs(hl.get_monitors()) do
		apply_monitor_layout(mon.name)
	end
end

hl.on("monitor.added", function(monitor)
	apply_monitor_layout(monitor.name)
end)
hl.on("hyprland.start", apply_all_connected)
hl.on("config.reloaded", apply_all_connected)

-- window rules
hl.window_rule({ name = "cel-ws-chrome", match = { class = "google-chrome" }, workspace = "1 silent" })
hl.window_rule({ name = "cel-ws-slack", match = { class = "com.slack.Slack" }, workspace = "2 silent" })
hl.window_rule({ name = "cel-ws-postman", match = { class = "Postman" }, workspace = "6 silent" })
hl.window_rule({ name = "cel-ws-datagrip", match = { class = "jetbrains-datagrip" }, workspace = "9 silent" })
hl.window_rule({
	name = "cel-ws-meet-sharing",
	match = { title = "^(meet%.google%.com is sharing your screen%.)$" },
	workspace = "10 silent",
})

local nord_network = os.getenv("NORD_NETWORK") or ""

hl.bind("ALT + V", hl.dsp.submap("vpn"))
hl.on("keybinds.submap", function(name)
	if name == "vpn" then
		hl.notification.create({ text = "VPN\n0-off  1-on  2-restart", duration = 3500 })
	end
end)

hl.define_submap("vpn", function()
	hl.bind("1", function()
		hl.dispatch(hl.dsp.exec_cmd("nordlayer connect " .. nord_network))
		hl.dsp.submap("reset")()
	end)
	hl.bind("2", function()
		hl.dispatch(hl.dsp.exec_cmd("sudo systemctl restart nordlayer"))
		hl.dsp.submap("reset")()
	end)
	hl.bind("0", function()
		hl.dispatch(hl.dsp.exec_cmd("nordlayer disconnect"))
		hl.dsp.submap("reset")()
	end)
	hl.bind("escape", hl.dsp.submap("reset"))
	hl.bind("Return", hl.dsp.submap("reset"))
end)
