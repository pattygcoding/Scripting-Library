-- Creates a new file, defaulting to a .txt extension.

local function main()
  local name = arg[1]
  if not name or name == "" then
    io.stderr:write("Usage: create-file.lua NAME\n")
    os.exit(1)
  end

  if not name:match("%.[^/\\]+$") then
    name = name .. ".txt"
  end

  local handle = io.open(name, "a")
  if not handle then
    io.stderr:write("Error: cannot create " .. name .. "\n")
    os.exit(1)
  end
  handle:close()

  print("Created " .. name)
end

main()
