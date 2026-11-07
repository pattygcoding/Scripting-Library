-- Measures how long a command takes to run.

local MAGENTA = "\27[35m"
local RESET = "\27[0m"

local has_socket, socket = pcall(require, "socket")

local function now()
  if has_socket and socket and socket.gettime then
    return socket.gettime()
  end
  return os.clock()
end

local function main()
  if #arg == 0 then
    io.stderr:write("Usage: time.lua COMMAND [ARGS...]\n")
    os.exit(1)
  end

  local command = table.concat(arg, " ")
  local start = now()
  local first, _, code = os.execute(command)
  local elapsed = now() - start

  local ok
  if first == true then
    ok = true
  elseif first == nil then
    ok = false
  else
    ok = (first == 0)
  end

  print(string.format("\n" .. MAGENTA .. "The task took %.6f seconds to complete." .. RESET .. "\n", elapsed))
  os.exit(ok and 0 or 1)
end

main()
