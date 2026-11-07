-- Converts a time to India Standard Time (IST).

local IST_OFFSET = 19800 -- 5.5 hours in seconds

local function format_ist(epoch)
  local t = os.date("!*t", epoch + IST_OFFSET)
  local hour = t.hour % 12
  if hour == 0 then
    hour = 12
  end
  local meridiem = t.hour < 12 and "AM" or "PM"
  return string.format("%02d:%02d %s", hour, t.min, meridiem)
end

local function main()
  local input = arg[1]

  if input then
    local hour, minute, meridiem = input:match("^(%d+):(%d+)%s*([AaPp][Mm])$")
    if not hour then
      io.stderr:write("Invalid time format. Use format like '8:26 AM'.\n")
      os.exit(1)
    end

    hour = tonumber(hour)
    if meridiem:lower() == "pm" and hour ~= 12 then
      hour = hour + 12
    elseif meridiem:lower() == "am" and hour == 12 then
      hour = 0
    end

    local today = os.date("*t")
    today.hour = hour
    today.min = tonumber(minute)
    today.sec = 0
    local base = os.time(today)

    print("Inputted time in India: " .. format_ist(base))
  else
    print("Current time in India: " .. format_ist(os.time()))
  end
end

main()
