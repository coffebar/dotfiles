#!/usr/bin/env lua

local e = os.execute

-- wireguard config
local conf = "~/dev/vpn/wg0-client-pc.conf"
local wg = "sudo /usr/bin/wg-quick "
-- openvpn connection name
local conn_name = "us2-openvpn-client"

local active = e("nmcli connection show --active | rg '^" .. conn_name .. "' >> /dev/null")
local action

local sys = require("lua.coffebar.sys").sys

local function disableOpenVPN()
  if not active then
    action = "was disabled"
    return
  end
  e("nmcli connection down " .. conn_name)
  action = "disabled"
end
local function enableOpenVPN()
  if active then
    action = "was connected"
    return
  end
  e("nmcli connection up " .. conn_name)
  action = "enabled"
end
local function enableWireguard()
  e(wg .. "up " .. conf)
  action = "enabled"
end
local function disableWireguard()
  e(wg .. "down " .. conf)
  action = "disabled"
end

local function showNotification()
  local ip = sys("curl -s --connect-timeout 5 https://api.ipify.org")
  local country = sys("geoiplookup " .. ip .. " | rg -Po '[A-Z]+, [a-zA-Z ]*$'")
  local message = "'" .. ip .. "\n" .. country .. "'"
  e(
    "notify-send -t 2500 -c vpn -i /usr/share/icons/breeze-dark/apps/48/alienarena.svg -a 'VPN "
      .. action
      .. "' "
      .. message
  )
end

if arg[1] == "1" then
  disableOpenVPN()
  enableWireguard()
else
  if arg[1] == "2" then
    disableWireguard()
    enableOpenVPN()
  else
    disableWireguard()
    disableOpenVPN()
  end
end

showNotification()
