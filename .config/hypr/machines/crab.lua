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
