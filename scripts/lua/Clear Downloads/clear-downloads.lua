-- Deletes everything inside the current user's Downloads folder.

local lfs = require("lfs")

local YELLOW = "\27[33m"
local GREEN = "\27[32m"
local RED = "\27[31m"
local RESET = "\27[0m"

local function remove_recursive(path)
  local attr = lfs.attributes(path)
  if not attr then
    return
  end

  if attr.mode == "directory" then
    for entry in lfs.dir(path) do
      if entry ~= "." and entry ~= ".." then
        remove_recursive(path .. "/" .. entry)
      end
    end
    lfs.rmdir(path)
  else
    os.remove(path)
  end
end

local function home_directory()
  return os.getenv("USERPROFILE") or os.getenv("HOME") or "."
end

local function main()
  local directory = arg[1] or (home_directory() .. "/Downloads")

  if lfs.attributes(directory, "mode") ~= "directory" then
    print(RED .. "Downloads folder not found: " .. directory .. RESET)
    os.exit(1)
  end

  print(YELLOW .. "Deleting all contents in " .. directory .. "..." .. RESET)
  for entry in lfs.dir(directory) do
    if entry ~= "." and entry ~= ".." then
      remove_recursive(directory .. "/" .. entry)
    end
  end
  print(GREEN .. "Downloads folder cleared permanently." .. RESET)
end

main()
