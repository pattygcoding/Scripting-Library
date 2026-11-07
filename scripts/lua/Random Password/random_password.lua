-- Generates a random password.

local CHARACTERS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+"
local DEFAULT_LENGTH = 12

local function seed_random()
  local entropy = os.time() + math.floor(os.clock() * 1000000)
  local address = tostring({}):match("0x(%x+)")
  if address then
    entropy = entropy + (tonumber(address, 16) % 1000000)
  end
  math.randomseed(entropy)
end

local function generate_password(length)
  local parts = {}
  for _ = 1, length do
    local index = math.random(#CHARACTERS)
    parts[#parts + 1] = CHARACTERS:sub(index, index)
  end
  return table.concat(parts)
end

local function main()
  seed_random()

  local length = tonumber(arg[1]) or DEFAULT_LENGTH
  if length < 1 then
    io.stderr:write("Error: length must be a positive integer.\n")
    os.exit(1)
  end

  print("Generated password: " .. generate_password(length))
end

main()
