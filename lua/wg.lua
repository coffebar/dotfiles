#!/usr/bin/env lua
-- toggle WireGuard VPN
local e = os.execute
local conf = "~/dev/vpn/wg0-client-pc.conf"
local wg = "sudo /usr/bin/wg-quick "
e(wg .. "down " .. conf .. " || " .. wg .. "up " .. conf)
e("dunstify -t 2500 'Toggle WireGuard' $(curl -s https://api.ipify.org)")
