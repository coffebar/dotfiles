#!/usr/bin/env lua

-- Alt + key pressed, key passed as arg
local key = arg[1]

local home = os.getenv("HOME")
local desktop_session = os.getenv("XDG_CURRENT_DESKTOP")

-- retrieve console command output
function os.capture(cmd)
	local handle = assert(io.popen(cmd, 'r'))
	local output = assert(handle:read('*a'))
	handle:close()
	return string.gsub(output, '%s+$', '')
end

if key == 'f' then
	-- Open file manager in context of clipboard
	local dir
	-- read from clipboard
	local buff = os.capture('xclip -selection c -o')
	local fch = string.sub(buff, 0, 1)
	if not string.find(buff, '\n') and (fch == "/" or fch == "~") then
		-- if clipboard has only 1 line
		-- try to get directory path from it
		dir = os.capture(string.format('dirname "%s"', buff))
	end
	if not dir or dir == "." or dir == "" then
		-- default directory to open
		dir = string.format('%s/Downloads', home)
	end
	os.execute(string.format('thunar "%s" &', dir))

elseif key == 't' then
	-- switch to Telegram or open new instance on fail
	local cmd = "telegram-desktop &"
	if desktop_session == "i3" then
		cmd = string.format("i3-msg workspace 2 & XDG_CURRENT_DESKTOP=gnome %s", cmd)
	end
	os.execute(string.format("wmctrl -a 'Telegram' || %s", cmd))
elseif key == 'i' then
	-- open PhpStorm IDE
	os.execute(string.format("GDK_SCALE='' %s/PhpStorm/bin/phpstorm.sh &", home))
	if desktop_session == "i3" then
		os.execute('i3-msg workspace 3')
	end
elseif key == 'b' then
	-- secondary browser
	os.execute("wmctrl -a ' - Google Chrome' || chromium &")
	if desktop_session == "i3" then
		os.execute('i3-msg workspace 4')
	end
elseif key == 'v' then
	-- toggle VPN
	local conf = string.format("%s/Sync/Work/vpn/wg0-client-pc.conf", home)
	os.execute(string.format("sudo /usr/bin/wg-quick down %s || sudo /usr/bin/wg-quick up %s", conf, conf))
end
