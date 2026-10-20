function extract_db_info(command)
  local db = command:match("FROM %[(%w+)%]") or command:match("UPDATE %[(%w+)%]") or "Unknown DB"
  local joins = {}
  for join in command:gmatch("JOIN %[(%w+)%]") do
    table.insert(joins, join)
  end
  if #joins > 0 then
    return "Executed DbCommand from DB [" .. db .. "] with joins: [" .. table.concat(joins, ", ") .. "]"
  else
    return "Executed DbCommand from DB [" .. db .. "]"
  end
end

function group_db_lines(lines)
  local grouped = {}
  local last_info = nil
  local current_lines = {}

  for _, entry in ipairs(lines) do
    local num, info = entry:match("^(%d+)%s+(.+)$")
    if info == last_info then
      table.insert(current_lines, num)
    else
      if #current_lines > 0 then
        table.insert(grouped, table.concat(current_lines, ", ") .. " " .. last_info)
      end
      current_lines = {num}
      last_info = info
    end
  end
  if #current_lines > 0 then
    table.insert(grouped, table.concat(current_lines, ", ") .. " " .. last_info)
  end
  return grouped
end

local file = arg[1] or "TestFile1.txt"
local f = io.open(file, "r")
if not f then
  print("\27[31mFile not found: " .. file .. "\27[0m")
  return
end

local lines = {}
for line in f:lines() do table.insert(lines, line) end
f:close()

local action_methods, actions, endpoints, db_lines = {}, {}, {}, {}
local current_db = ""
local start_line = nil

for i, line in ipairs(lines) do
  local num = tostring(i)
  if line:match("Executed action method") then
    table.insert(action_methods, num .. " " .. line)
  elseif line:match("Executed action") then
    table.insert(actions, num .. " " .. line)
  elseif line:match("Executed endpoint") then
    table.insert(endpoints, num .. " " .. line)
  elseif line:match("Executed DbCommand") then
    if current_db ~= "" then
      table.insert(db_lines, start_line .. " " .. extract_db_info(current_db))
    end
    current_db = line
    start_line = num
  elseif current_db ~= "" then
    current_db = current_db .. "\n" .. line
  end
end

if current_db ~= "" then
  table.insert(db_lines, start_line .. " " .. extract_db_info(current_db))
end

local grouped_db = group_db_lines(db_lines)

print("\n--- Executed DbCommands ---")
for _, line in ipairs(grouped_db) do print("\27[33m" .. line .. "\27[0m") end

print("\n--- Executed Action Methods ---")
for _, line in ipairs(action_methods) do print("\27[33m" .. line .. "\27[0m") end

print("\n--- Executed Actions ---")
for _, line in ipairs(actions) do print("\27[33m" .. line .. "\27[0m") end

print("\n--- Executed Endpoints ---")
for _, line in ipairs(endpoints) do print("\27[33m" .. line .. "\27[0m") end
