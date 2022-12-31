#!/usr/bin/env lua

-- Alt + key pressed, key passed as arg
local key = arg[1]

local home = os.getenv("HOME")
local desktop_session = os.getenv("XDG_CURRENT_DESKTOP")
if desktop_session and string.match(desktop_session, "i3") then
	desktop_session = "i3"
end

-- retrieve system command output
local function sys(cmd)
	local handle = assert(io.popen(cmd, "r"))
	local output = assert(handle:read("*a"))
	handle:close()
	return string.gsub(output, "%s+$", "")
end

local function dir_exists(path)
	if not path or path == "" then
		return false
	end
	if not string.match(path, "['#\"]") == nil then
		-- checked for multiline before this function call
		return false
	end
	return os.execute("test -d '" .. path .. "'")
end

if key == "f" then
	-- Open file manager in context of clipboard
	local dir
	-- read from clipboard
	local buff = sys("xclip -selection c -o")
	local fch = string.sub(buff, 0, 1)
	if not string.find(buff, "\n") and (fch == "/" or fch == "~") then
		-- if clipboard has only 1 line
		-- try to get directory path from it
		dir = sys(string.format('dirname "%s"', buff))
	end
	if dir == "." or not dir_exists(dir) then
		-- default directory to open
		dir = home .. "/Downloads"
	end
	os.execute(string.format('thunar "%s" &', dir))
elseif key == "t" then
	-- switch to Telegram or open new instance on fail
	local cmd = "telegram-desktop &"
	if desktop_session == "i3" then
		local msg = sys("i3-msg '[class=\"^TelegramDesktop$\"] focus'")
		if not string.match(msg, '"success":true') then
			os.execute("XDG_CURRENT_DESKTOP=gnome " .. cmd)
			os.execute("sleep 1 && i3-msg '[class=\"^TelegramDesktop$\"] focus'")
		end
	else
		os.execute(string.format("wmctrl -a 'Telegram' || %s", cmd))
	end
elseif key == "b" then
	-- secondary browser
	os.execute("wmctrl -a 'Mozilla Firefox' || firefox -P default-release &")
end
