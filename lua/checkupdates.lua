#!/usr/bin/env lua
-- check for pending packages update

local sys = require("lua.coffebar.sys").sys

local updates = sys("checkupdates 2> /dev/null | wc -l")
if updates == "0" then
	os.exit(1)
end
print(updates)
