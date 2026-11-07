-- Summarizes DbCommands, actions, action methods and endpoints from a .NET log.

local CYAN = "\27[36m"
local YELLOW = "\27[33m"
local RED = "\27[31m"
local RESET = "\27[0m"

local function extract_db_info(command)
  local db = command:match("FROM %[(%w+)%]") or command:match("UPDATE %[(%w+)%]") or "Unknown DB"
  local joins = {}
  for join in command:gmatch("JOIN %[(%w+)%]") do
    table.insert(joins, join)
  end
  if #joins > 0 then
    return "Executed DbCommand from DB [" .. db .. "] with joins: [" .. table.concat(joins, ", ") .. "]"
  end
  return "Executed DbCommand from DB [" .. db .. "]"
end

local function group_db_lines(lines)
  local grouped = {}
  local last_info = nil
  local current = {}

  for _, entry in ipairs(lines) do
    local num, info = entry:match("^(%d+)%s+(.+)$")
    if info == last_info then
      table.insert(current, num)
    else
      if #current > 0 then
        table.insert(grouped, table.concat(current, ", ") .. " " .. last_info)
      end
      current = { num }
      last_info = info
    end
  end
  if #current > 0 then
    table.insert(grouped, table.concat(current, ", ") .. " " .. last_info)
  end
  return grouped
end

local function print_section(title, lines)
  print("\n" .. CYAN .. "--- " .. title .. " ---" .. RESET)
  for _, line in ipairs(lines) do
    print(YELLOW .. line .. RESET)
  end
end

local function main()
  local file = arg[1] or "TestFile1.txt"
  local handle = io.open(file, "r")
  if not handle then
    print(RED .. "File not found: " .. file .. RESET)
    os.exit(1)
  end

  local action_methods, actions, endpoints, db_lines = {}, {}, {}, {}
  local current_db = ""
  local start_line = nil
  local number = 0

  for line in handle:lines() do
    number = number + 1
    if line:match("Executed action method") then
      table.insert(action_methods, number .. " " .. line)
    elseif line:match("Executed action") then
      table.insert(actions, number .. " " .. line)
    elseif line:match("Executed endpoint") then
      table.insert(endpoints, number .. " " .. line)
    elseif line:match("Executed DbCommand") then
      if current_db ~= "" then
        table.insert(db_lines, start_line .. " " .. extract_db_info(current_db))
      end
      current_db = line
      start_line = number
    elseif current_db ~= "" then
      current_db = current_db .. "\n" .. line
    end
  end
  handle:close()

  if current_db ~= "" then
    table.insert(db_lines, start_line .. " " .. extract_db_info(current_db))
  end

  print_section("Executed DbCommands", group_db_lines(db_lines))
  print_section("Executed Action Methods", action_methods)
  print_section("Executed Actions", actions)
  print_section("Executed Endpoints", endpoints)
end

main()
