-- Prints the machine's IPv4 addresses.

local IS_WINDOWS = package.config:sub(1, 1) == "\\"

local function main()
  local command
  if IS_WINDOWS then
    command = "ipconfig"
  else
    command = "ifconfig -a 2>/dev/null || ip -4 addr 2>/dev/null"
  end

  local addresses = {}
  local seen = {}

  local handle = io.popen(command)
  if handle then
    local output = handle:read("*a")
    handle:close()

    for address in output:gmatch("(%d+%.%d+%.%d+%.%d+)") do
      if not seen[address]
          and address ~= "127.0.0.1"
          and address ~= "0.0.0.0"
          and address ~= "255.255.255.255"
          and not address:match("^255%.") then
        seen[address] = true
        table.insert(addresses, address)
      end
    end
  end

  table.sort(addresses)
  for _, address in ipairs(addresses) do
    print(address)
  end
end

main()
