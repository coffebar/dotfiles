local home = os.getenv("HOME")
hl.env(
	"PATH",
	home
		.. "/go/bin:"
		.. home
		.. "/.local/share/JetBrains/Toolbox/scripts:"
		.. home
		.. "/.local/bin:"
		.. home
		.. "/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/snap/bin:"
		.. home
		.. "/.local/share/lua-language-server/bin:/usr/libexec"
)
-- monitors
local laptop_monitor = "eDP-1"
hl.monitor({ output = laptop_monitor, mode = "1920x1200@60", position = "auto", scale = "1.2" })
hl.monitor({ output = "desc:Dell Inc. DELL P2722HE D0TCBH3", mode = "1920x1080", position = "0x0", scale = "1" })
hl.monitor({ output = "desc:Dell Inc. DELL P2719H 7JJ9QS2", mode = "1920x1080", position = "3520x0", scale = "1" })

-- workspace rules
hl.workspace_rule({ workspace = "4", monitor = laptop_monitor })
hl.workspace_rule({ workspace = "5", monitor = laptop_monitor })
hl.workspace_rule({ workspace = "6", monitor = laptop_monitor })

-- core overrides
hl.config({
	input = {
		kb_layout = "us,ru,ua",
	},
})

-- autostart
hl.on("hyprland.start", function()
	hl.exec_cmd("foot")
	hl.exec_cmd("google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland")
	hl.exec_cmd("datagrip")
	hl.exec_cmd("~/.local/bin/token-vault")
	hl.exec_cmd("vpn on")
end)

local function move_workspaces(assignments)
	for ws, mon in pairs(assignments) do
		-- hl.dispatch(hl.dsp.workspace.move({ workspace = ws, monitor = mon }))
		hl.workspace_rule({ workspace = ws, monitor = mon })
	end
end

local function apply_monitor_layout(name)
	if name == "DP-5" then
		hl.monitor({ output = laptop_monitor, mode = "1920x1200@60", position = "1920x0", scale = "1.2" })
		move_workspaces({
			[1] = name,
			[2] = name,
			[3] = name,
			[7] = "DP-6",
			[8] = "DP-6",
			[9] = "DP-6",
		})
	elseif name == "DP-8" then
		hl.monitor({ output = laptop_monitor, mode = "1920x1200@60", position = "1920x0", scale = "1.2" })
		move_workspaces({
			[1] = "DP-7",
			[2] = "DP-7",
			[3] = "DP-7",
			[7] = name,
			[8] = name,
			[9] = name,
		})
	elseif name == "DP-3" or name == "DP-1" then
		hl.monitor({ output = laptop_monitor, mode = "1920x1200@60", position = "0x1441", scale = "1.2" })
		move_workspaces({
			[1] = name,
			[2] = name,
			[3] = name,
			[7] = name,
			[8] = name,
			[9] = name,
		})
	end
end

local function apply_all_connected()
	for _, mon in ipairs(hl.get_monitors()) do
		apply_monitor_layout(mon.name)
	end
end

hl.on("monitor.added", function(monitor)
	apply_monitor_layout(monitor.name)
	hl.exec_cmd("sudo systemctl restart nordlayer")
end)
hl.on("hyprland.start", function()
	apply_all_connected()
end)
hl.on("config.reloaded", function()
	apply_all_connected()
end)

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

hl.bind("ALT + V", hl.dsp.submap("vpn"))
hl.on("keybinds.submap", function(name)
	if name == "vpn" then
		hl.notification.create({
			text = "VPN:\n0-off\n1-on\n2-restart",
			duration = 5000,
			color = "rgb(B0EA1F)",
			font_size = 18,
		})
	end
end)

hl.define_submap("vpn", function()
	hl.bind("1", function()
		hl.dispatch(hl.dsp.submap("reset"))
		hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
		hl.dispatch(hl.dsp.exec_cmd("vpn on"))
		hl.timer(function()
			hl.notification.create({
				text = "Connecting to VPN",
				duration = 2000,
				color = "rgb(B0EA1F)",
				font_size = 18,
			})
		end, { timeout = 100, type = "oneshot" })
	end)
	hl.bind("2", function()
		hl.dispatch(hl.dsp.submap("reset"))
		hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
		hl.dispatch(hl.dsp.exec_cmd("sudo systemctl restart nordlayer"))
	end)
	hl.bind("0", function()
		hl.dispatch(hl.dsp.submap("reset"))
		hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
		hl.dispatch(hl.dsp.exec_cmd("vpn off"))
		hl.timer(function()
			hl.notification.create({
				text = "Disconnecting from NordVPN",
				duration = 2000,
				color = "rgb(B0EA1F)",
				font_size = 18,
			})
		end, { timeout = 100, type = "oneshot" })
	end)
	hl.bind("escape", function()
		hl.dispatch(hl.dsp.submap("reset"))
		hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
	end)
	hl.bind("Return", function()
		hl.dispatch(hl.dsp.submap("reset"))
		hl.dispatch(hl.dsp.exec_cmd("hyprctl dismissnotify"))
	end)
end)
