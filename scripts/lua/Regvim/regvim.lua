-- Finds files by name and opens each match in Vim.

local lfs = require("lfs")

local YELLOW = "\27[33m"
local RED = "\27[31m"
local RESET = "\27[0m"

local function find(directory, name, results)
  for entry in lfs.dir(directory) do
    if entry ~= "." and entry ~= ".." then
      local full = directory .. "/" .. entry
      local attr = lfs.attributes(full)
      if attr then
        if attr.mode == "directory" then
          find(full, name, results)
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
    io.stderr:write("Usage: regvim.lua FILE\n")
    os.exit(1)
  end

  local matches = {}
  find(".", name, matches)

  if #matches == 0 then
    io.stderr:write(RED .. "No instances of '" .. name .. "' found." .. RESET .. "\n")
    os.exit(1)
  end

  table.sort(matches)
  for _, path in ipairs(matches) do
    print(YELLOW .. "Opening " .. path .. " in vim" .. RESET)
    os.execute('vim "' .. path .. '"')
  end
end

main()
