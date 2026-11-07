-- Prints the path of a frequently used directory.
--
-- A child process cannot change its parent shell's working directory, so this
-- prints the destination instead. Use it as: cd "$(lua goto.lua repos)"

local DESTINATIONS = {
  locals = "", -- Insert your locals path here
  repos = "",  -- Insert your repos path here
}

local function main()
  local target = arg[1]
  local path = target and DESTINATIONS[target:lower()]

  if not path or path == "" then
    io.stderr:write("Option '" .. tostring(target) .. "' does not exist.\n\n")
    io.stderr:write("Available options:\n")
    for name, dest in pairs(DESTINATIONS) do
      io.stderr:write(string.format("  %-8s - %s\n", name, dest))
    end
    os.exit(1)
  end

  print(path)
end

main()
