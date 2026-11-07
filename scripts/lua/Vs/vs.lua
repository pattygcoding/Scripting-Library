-- Finds a file by name and opens it in Visual Studio.

local lfs = require("lfs")

local YELLOW = "\27[33m"
local RED = "\27[31m"
local RESET = "\27[0m"

local IGNORE_DIRS = { bin = true, obj = true, [".git"] = true, node_modules = true }

local function find(directory, name, results)
  for entry in lfs.dir(directory) do
    if entry ~= "." and entry ~= ".." then
      local full = directory .. "/" .. entry
      local attr = lfs.attributes(full)
      if attr then
        if attr.mode == "directory" then
          if not IGNORE_DIRS[entry] then
            find(full, name, results)
          end
        elseif entry == name then
          table.insert(results, full)
        end
      end
    end
  end
end

local function main()
  local name = arg[1]
  if not name or name == "" then
    io.stderr:write("Usage: vs.lua FILE\n")
    os.exit(1)
  end

  local search_file = name:match("%.") and name or (name .. ".cs")

  local matches = {}
  find(".", search_file, matches)

  if #matches == 0 then
    io.stderr:write(RED .. "No instances of '" .. search_file .. "' found." .. RESET .. "\n")
    os.exit(1)
  end

  local quoted = {}
  for _, path in ipairs(matches) do
    quoted[#quoted + 1] = '"' .. path .. '"'
  end
  os.execute("devenv.exe /Edit " .. table.concat(quoted, " "))

  for _, path in ipairs(matches) do
    print(YELLOW .. "Opened: " .. path .. RESET)
  end
end

main()
