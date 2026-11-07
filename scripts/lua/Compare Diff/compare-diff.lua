-- Compares two text files line by line and highlights the differences.

local RED = "\27[91m"
local GREEN = "\27[92m"
local YELLOW = "\27[93m"
local RESET = "\27[0m"

local TIMESTAMP = "%[%d%d:%d%d:%d%d%s%w%w%w%]|%(%d+ms%)"

local function trim(text)
  return (text:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function read_lines(path)
  local handle = io.open(path, "r")
  if not handle then
    return nil
  end

  local lines = {}
  for line in handle:lines() do
    table.insert(lines, line)
  end
  handle:close()
  return lines
end

local function main()
  local notime = false
  local files = {}
  for _, value in ipairs(arg) do
    if value == "--notime" then
      notime = true
    else
      files[#files + 1] = value
    end
  end

  local file1 = files[1] or "TestFile1.txt"
  local file2 = files[2] or "TestFile2.txt"

  local content1 = read_lines(file1)
  local content2 = read_lines(file2)
  if not content1 or not content2 then
    io.stderr:write(RED .. "Error: cannot read input file." .. RESET .. "\n")
    os.exit(1)
  end

  if notime then
    print(YELLOW .. "Please note that since you included the --notime flag, timestamps will not be compared or displayed." .. RESET)
    for i = 1, #content1 do
      content1[i] = content1[i]:gsub(TIMESTAMP, "")
    end
    for i = 1, #content2 do
      content2[i] = content2[i]:gsub(TIMESTAMP, "")
    end
  end

  print("\n" .. RED .. "RED = " .. file1 .. RESET)
  print(GREEN .. "GREEN = " .. file2 .. RESET .. "\n")

  local differences = 0
  local max = math.max(#content1, #content2)
  for i = 1, max do
    local line1 = content1[i]
    local line2 = content2[i]
    if line1 ~= line2 then
      if line1 then
        print(RED .. "- " .. trim(line1) .. RESET)
        differences = differences + 1
      end
      if line2 then
        print(GREEN .. "+ " .. trim(line2) .. RESET)
        differences = differences + 1
      end
    end
  end

  os.exit(differences == 0 and 0 or 1)
end

main()
