-- Safely extracts a ZIP archive with zip-bomb and traversal protections.

local DEFAULT_MAX_FILES = 1000
local DEFAULT_MAX_BYTES = 500 * 1024 * 1024

local IS_WINDOWS = package.config:sub(1, 1) == "\\"

local function u16(data, pos)
  local a, b = data:byte(pos, pos + 1)
  if not a or not b then
    return nil
  end
  return a + b * 256
end

local function u32(data, pos)
  local a, b, c, d = data:byte(pos, pos + 3)
  if not a or not b or not c or not d then
    return nil
  end
  return a + b * 256 + c * 65536 + d * 16777216
end

local function find_eocd(data)
  local first = math.max(1, #data - 22 - 65535)
  for i = #data - 21, first, -1 do
    if data:sub(i, i + 3) == "\80\75\5\6" then
      return i
    end
  end
  return nil
end

-- Reads the ZIP central directory and returns a list of { name, size } entries.
local function read_entries(data)
  local eocd = find_eocd(data)
  if not eocd then
    return nil
  end

  local count = u16(data, eocd + 10)
  local offset = u32(data, eocd + 16)
  if not count or not offset then
    return nil
  end

  local entries = {}
  local pos = offset + 1
  for _ = 1, count do
    if data:sub(pos, pos + 3) ~= "\80\75\1\2" then
      break
    end

    local uncompressed = u32(data, pos + 24)
    local name_len = u16(data, pos + 28)
    local extra_len = u16(data, pos + 30)
    local comment_len = u16(data, pos + 32)
    if not uncompressed or not name_len then
      break
    end

    local name = data:sub(pos + 46, pos + 46 + name_len - 1)
    entries[#entries + 1] = { name = name, size = uncompressed }
    pos = pos + 46 + name_len + extra_len + comment_len
  end
  return entries
end

local function is_unsafe(name)
  local normalized = name:gsub("\\", "/")
  return normalized == ""
    or normalized == "."
    or normalized:sub(1, 3) == "../"
    or normalized:find("/../", 1, true) ~= nil
end

local function extract(zip_path, destination)
  if IS_WINDOWS then
    return os.execute(string.format(
      'powershell -NoProfile -Command "Expand-Archive -LiteralPath \'%s\' -DestinationPath \'%s\' -Force"',
      zip_path, destination))
  end
  return os.execute(string.format('unzip -o "%s" -d "%s"', zip_path, destination))
end

local function main()
  local max_files = DEFAULT_MAX_FILES
  local max_bytes = DEFAULT_MAX_BYTES
  local zip_path

  local i = 1
  while i <= #arg do
    if arg[i] == "--max-file-count" then
      max_files = tonumber(arg[i + 1]) or max_files
      i = i + 2
    elseif arg[i] == "--max-total-size" then
      max_bytes = tonumber(arg[i + 1]) or max_bytes
      i = i + 2
    else
      zip_path = arg[i]
      i = i + 1
    end
  end

  if not zip_path then
    io.stderr:write("Error: provide a ZIP path.\n")
    os.exit(1)
  end

  local handle = io.open(zip_path, "rb")
  if not handle then
    io.stderr:write("Error: zip file not found: " .. zip_path .. "\n")
    os.exit(1)
  end
  local data = handle:read("*a")
  handle:close()

  local entries = read_entries(data)
  if not entries then
    io.stderr:write("Extraction failed: not a valid ZIP archive.\n")
    os.exit(1)
  end

  local count, total = 0, 0
  for _, entry in ipairs(entries) do
    if is_unsafe(entry.name) then
      io.stderr:write("Extraction failed: unsafe path detected in entry '" .. entry.name .. "'\n")
      os.exit(1)
    end
    if entry.size > 0 then
      count = count + 1
      total = total + entry.size
      if count > max_files then
        io.stderr:write("Extraction failed: file count exceeds " .. max_files .. "\n")
        os.exit(1)
      end
      if total > max_bytes then
        io.stderr:write("Extraction failed: total size exceeds " .. math.floor(max_bytes / (1024 * 1024)) .. " MB\n")
        os.exit(1)
      end
    end
  end

  local destination = zip_path:gsub("%.[^./\\]+$", "") .. "_unzipped"
  extract(zip_path, destination)
  print("Extracted to: " .. destination)
end

main()
