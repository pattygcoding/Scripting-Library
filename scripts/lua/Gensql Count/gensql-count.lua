-- Generates a SQL script to count the entries in a table.

local MAGENTA = "\27[35m"
local RESET = "\27[0m"

local function main()
  local table_name
  local i = 1
  while i <= #arg do
    if arg[i] == "-t" or arg[i] == "--table" then
      table_name = arg[i + 1]
      i = i + 2
    else
      i = i + 1
    end
  end

  if not table_name then
    io.stderr:write("Error: -t/--table is required.\n")
    os.exit(1)
  end

  print(MAGENTA .. "SELECT COUNT(*) AS total_entries\nFROM " .. table_name .. ";\n" .. RESET)
end

main()
