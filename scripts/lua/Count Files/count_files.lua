-- Counts files in the current directory tree, grouped by extension.

local lfs = require("lfs")

local CYAN = "\27[96m"
local YELLOW = "\27[93m"
local RESET = "\27[0m"

local function collect_files(directory, include_node, results)
  for entry in lfs.dir(directory) do
    if entry ~= "." and entry ~= ".." then
      local full_path = directory .. "/" .. entry
      local attr = lfs.attributes(full_path)
      if attr then
        if attr.mode == "directory" then
          collect_files(full_path, include_node, results)
        elseif include_node or not full_path:find("node_modules", 1, true) then
          table.insert(results, full_path)
        end
      end
    end
  end
end

local function main()
  local include_node = false
  for _, value in ipairs(arg) do
    if value == "--includenode" then
      include_node = true
    end
  end

  local files = {}
  collect_files(lfs.currentdir(), include_node, files)

  local by_extension = {}
  for _, file in ipairs(files) do
    local ext = file:match("^.+(%..+)$") or ""
    by_extension[ext] = (by_extension[ext] or 0) + 1
  end

  print(CYAN .. "Total number of files: " .. RESET .. YELLOW .. #files .. RESET)
  print(CYAN .. "Files by extension:" .. RESET)

  local extensions = {}
  for ext in pairs(by_extension) do
    table.insert(extensions, ext)
  end
  table.sort(extensions)

  for _, ext in ipairs(extensions) do
    print(YELLOW .. ext .. ": " .. by_extension[ext] .. RESET)
  end
end

main()
