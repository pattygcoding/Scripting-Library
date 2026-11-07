-- Converts a JSON file (an array of objects) into a CSV file.
--
-- Requires the dkjson library: luarocks install dkjson

local ok, json = pcall(require, "dkjson")
if not ok then
  io.stderr:write("This script requires the dkjson library: luarocks install dkjson\n")
  os.exit(1)
end

local function main()
  local json_file = arg[1] or "data.json"
  local csv_file = arg[2] or "data.csv"

  local handle = io.open(json_file, "r")
  if not handle then
    io.stderr:write("Error: cannot open " .. json_file .. "\n")
    os.exit(1)
  end
  local content = handle:read("*a")
  handle:close()

  local data = json.decode(content)
  if not data or #data == 0 then
    io.stderr:write("Error: the JSON file contains no rows.\n")
    os.exit(1)
  end

  local headers = {}
  for key in pairs(data[1]) do
    table.insert(headers, key)
  end
  table.sort(headers)

  local out = io.open(csv_file, "w")
  if not out then
    io.stderr:write("Error: cannot write " .. csv_file .. "\n")
    os.exit(1)
  end

  out:write(table.concat(headers, ",") .. "\n")
  for _, row in ipairs(data) do
    local values = {}
    for _, header in ipairs(headers) do
      values[#values + 1] = tostring(row[header])
    end
    out:write(table.concat(values, ",") .. "\n")
  end
  out:close()

  print("Wrote " .. csv_file)
end

main()
