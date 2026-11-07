-- Prints text with optional ANSI color.

local COLORS = {
  black = 30,
  red = 91,
  green = 92,
  yellow = 93,
  blue = 94,
  magenta = 95,
  cyan = 96,
  white = 97,
}

local function main()
  local color
  local newline = true
  local message = {}

  local i = 1
  while i <= #arg do
    if arg[i] == "--color" then
      color = arg[i + 1]
      i = i + 2
    elseif arg[i] == "--no-newline" then
      newline = false
      i = i + 1
    else
      message[#message + 1] = arg[i]
      i = i + 1
    end
  end

  local text = table.concat(message, " ")
  if color and COLORS[color] then
    text = "\27[" .. COLORS[color] .. "m" .. text .. "\27[0m"
  end

  if newline then
    print(text)
  else
    io.write(text)
  end
end

main()
