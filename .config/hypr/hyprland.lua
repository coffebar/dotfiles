require("modules.env")
require("modules.monitors")
require("modules.core")
require("modules.autostart")
require("modules.rules")
require("modules.binds")

local machine = os.getenv("XDG_SESSION_OPT") or "cel"
pcall(require, "machines." .. machine)
