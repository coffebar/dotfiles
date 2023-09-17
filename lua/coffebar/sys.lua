local P = {}

function P.sys(cmd)
  -- retrieve system command output
  local handle = assert(io.popen(cmd, "r"))
  local output = assert(handle:read("*a"))
  handle:close()
  return string.gsub(output, "%s+$", "")
end

return P
