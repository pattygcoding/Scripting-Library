-- Builds and updates an index of .cs files under a directory tree.

local lfs = require("lfs")

local CYAN = "\27[36m"
local GREEN = "\27[32m"
local RESET = "\27[0m"

local function read_index(path)
  local index = {}
  local handle = io.open(path, "r")
  if not handle then
    return index
  end

  for line in handle:lines() do
    local name, dirs = line:match("^(.-)|(.*)$")
    if name and dirs and dirs ~= "" then
      index[name] = index[name] or {}
      for dir in dirs:gmatch("[^;]+") do
        index[name][dir] = true
      end
    end
  end
  handle:close()
  return index
end

local function scan(directory, index)
  for entry in lfs.dir(directory) do
    if entry ~= "." and entry ~= ".." then
      local full = directory .. "/" .. entry
      local attr = lfs.attributes(full)
      if attr then
        if attr.mode == "directory" then
          scan(full, index)
        elseif entry:lower():match("%.cs$") then
          local name = entry:sub(1, -4)
          index[name] = index[name] or {}
          index[name][directory] = true
        end
      end
    end
  end
end

local function write_index(path, index)
  local names = {}
  for name in pairs(index) do
    table.insert(names, name)
  end
  table.sort(names)

  local handle = io.open(path, "w")
  for _, name in ipairs(names) do
    local dirs = {}
    for dir in pairs(index[name]) do
      table.insert(dirs, dir)
    end
    table.sort(dirs)
    handle:write(name .. "|" .. table.concat(dirs, ";") .. "\n")
  end
  handle:close()
end

local function sets_equal(a, b)
  for key in pairs(a) do
    if not b[key] then
      return false
    end
  end
  for key in pairs(b) do
    if not a[key] then
      return false
    end
  end
  return true
end

local function main()
  local root = "."
  local index_file

  local i = 1
  while i <= #arg do
    if arg[i] == "--root" then
      root = arg[i + 1]
      i = i + 2
    elseif arg[i] == "--index-file" then
      index_file = arg[i + 1]
      i = i + 2
    else
      i = i + 1
    end
  end

  if not index_file then
    io.stderr:write("Error: --index-file is required.\n")
    os.exit(1)
  end

  local old = read_index(index_file)
  local new = {}
  scan(root, new)

  local added, removed, changed = 0, 0, 0
  local merged = {}

  for name, dirs in pairs(old) do
    if not new[name] then
      removed = removed + 1
    elseif sets_equal(dirs, new[name]) then
      merged[name] = dirs
    else
      changed = changed + 1
      merged[name] = new[name]
    end
  end
  for name, dirs in pairs(new) do
    if not old[name] then
      added = added + 1
      merged[name] = dirs
    end
  end

  write_index(index_file, merged)

  if added + removed + changed == 0 then
    print(GREEN .. "No changes detected in .cs files under '" .. root .. "'." .. RESET)
  else
    print(CYAN .. "Index updated: +" .. added .. " / -" .. removed .. " / *" .. changed .. RESET)
  end
end

main()
