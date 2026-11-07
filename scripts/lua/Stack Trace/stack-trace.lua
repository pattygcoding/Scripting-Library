-- Extracts the relative file paths from a .NET stack trace.

local YELLOW = "\27[33m"
local RESET = "\27[0m"

local function main()
  local path = arg[1] or "test.txt"
  local handle = io.open(path, "r")
  if not handle then
    io.stderr:write("File not found: " .. path .. "\n")
    os.exit(1)
  end

  local text = handle:read("*a")
  handle:close()

  for line in text:gmatch("[^\r\n]+") do
    local trimmed = line:gsub("^%s+", "")
    if trimmed:match("^at ") and not trimmed:match("^at Microsoft") then
      local rel = trimmed:match(" in (.+)$")
      if rel then
        rel = rel:gsub("[\\]+", "/")
        rel = rel:gsub("/+", "/")
        rel = rel:gsub("^%a:/a/1/s/", "")
        print(YELLOW .. rel .. RESET)
      end
    end
  end
end

main()
