-- Starts a React development server and opens it in the browser.

local DEFAULT_PORT = 3000
local DEFAULT_COMMAND = "npm start"

local IS_WINDOWS = package.config:sub(1, 1) == "\\"

local function spawn(command)
  if IS_WINDOWS then
    os.execute('start "" ' .. command)
  else
    os.execute(command .. " >/dev/null 2>&1 &")
  end
end

local function open_browser(port)
  local url = "http://localhost:" .. port .. "/"
  if IS_WINDOWS then
    os.execute('start "" ' .. url)
  else
    os.execute("(xdg-open " .. url .. " || open " .. url .. ") >/dev/null 2>&1 &")
  end
end

local function main()
  local port = DEFAULT_PORT
  local command = DEFAULT_COMMAND

  local i = 1
  while i <= #arg do
    if arg[i] == "--port" then
      port = tonumber(arg[i + 1]) or DEFAULT_PORT
      i = i + 2
    elseif arg[i] == "--command" then
      command = arg[i + 1]
      i = i + 2
    else
      i = i + 1
    end
  end

  spawn(command)
  open_browser(port)
end

main()
