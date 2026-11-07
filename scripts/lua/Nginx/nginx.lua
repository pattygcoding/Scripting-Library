-- Starts or reloads a local Nginx server.

local function is_running()
  local handle = io.popen('tasklist /FI "IMAGENAME eq nginx.exe" 2>NUL')
  if not handle then
    return false
  end
  local output = handle:read("*a")
  handle:close()
  return output:find("nginx.exe", 1, true) ~= nil
end

local function main()
  local base = "" -- Insert the path to your nginx installation here.

  local i = 1
  while i <= #arg do
    if arg[i] == "--base" then
      base = arg[i + 1]
      i = i + 2
    else
      i = i + 1
    end
  end

  if base == "" then
    io.stderr:write("Error: nginx not found. Pass --base with your installation directory.\n")
    os.exit(1)
  end

  local exe = base .. "/nginx.exe"
  local conf = base .. "/conf/nginx.conf"

  if is_running() then
    os.execute('cd /d "' .. base .. '" && "' .. exe .. '" -s reload')
  else
    os.execute('cd /d "' .. base .. '" && "' .. exe .. '" -c "' .. conf .. '"')
  end
end

main()
