#!/usr/bin/env lua
-- toggle OpenVPN
local e = os.execute
local conn_name = "us2-openvpn-client"

local active = e("nmcli connection show --active | rg '^" .. conn_name .. "' >> /dev/null")
local action
if active then
	e("nmcli connection down " .. conn_name)
	action = "disabled"
else
	e("nmcli connection up " .. conn_name)
	action = "enabled"
end
e("dunstify -t 2500 'OpenVPN " .. action .. "' $(curl -s https://api.ipify.org)")