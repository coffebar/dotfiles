hl.on("hyprland.start", function()
	hl.exec_cmd("/bin/sh -c \"secret-tool lookup 'keepass' 'default' | keepassxc --pw-stdin ~/KeePass/database.kdbx\"")
	hl.exec_cmd("/bin/bash ~/Downloads/Telegram\\ Desktop/unzip_here.sh")
	hl.exec_cmd("/usr/lib/thunderbird/thunderbird")
	hl.exec_cmd("firefox")
end)

local external_monitor = "desc:BNQ BenQ PD2705U 89P03368019"
local laptop_monitor = "eDP-1"
hl.workspace_rule({ workspace = "1", monitor = external_monitor })
hl.workspace_rule({ workspace = "2", monitor = external_monitor })
hl.workspace_rule({ workspace = "3", monitor = external_monitor })
hl.workspace_rule({ workspace = "4", monitor = laptop_monitor })
hl.workspace_rule({ workspace = "5", monitor = laptop_monitor })
hl.workspace_rule({ workspace = "6", monitor = laptop_monitor })
hl.workspace_rule({ workspace = "8", monitor = external_monitor })
hl.workspace_rule({ workspace = "9", monitor = external_monitor })

local laptop_monitor_selector = "desc:BOE 0x094C"

local function set_laptop_panel(enabled)
	hl.monitor({
		output = laptop_monitor_selector,
		mode = "1920x1200@60",
		position = "0x1440",
		scale = "1",
		disabled = not enabled,
	})
end

local function is_docked()
	for _, mon in ipairs(hl.get_monitors()) do
		if mon.name ~= laptop_monitor then
			return true
		end
	end
	return false
end

local function lid_closed()
	local f = io.popen("cat /proc/acpi/button/lid/*/state 2>/dev/null")
	if not f then
		return false
	end
	local out = f:read("*a")
	f:close()
	return out:find("closed") ~= nil
end

hl.bind("switch:on:Lid Switch", function()
	if is_docked() then
		set_laptop_panel(false)
	end
end, { locked = true })

hl.bind("switch:off:Lid Switch", function()
	set_laptop_panel(true)
end, { locked = true })

hl.on("monitor.removed", function(mon)
	if mon.name ~= laptop_monitor and not is_docked() then
		set_laptop_panel(true)
	end
end)

local function sync_laptop_panel()
	if lid_closed() and is_docked() then
		set_laptop_panel(false)
	end
end

hl.on("hyprland.start", sync_laptop_panel)
hl.on("config.reloaded", sync_laptop_panel)
