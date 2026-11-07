-- Cleans, builds, and tests a .NET unit test project.

local YELLOW = "\27[33m"
local RESET = "\27[0m"

-- Insert the path to your .csproj here.
local PROJECT_PATH = ""

local function main()
  local project = PROJECT_PATH

  local i = 1
  while i <= #arg do
    if arg[i] == "--project" then
      project = arg[i + 1]
      i = i + 2
    else
      i = i + 1
    end
  end

  if project == "" then
    io.stderr:write("Error: set --project or PROJECT_PATH to your .csproj.\n")
    os.exit(1)
  end

  print(YELLOW .. "Cleaning..." .. RESET)
  os.execute('dotnet clean "' .. project .. '"')

  print(YELLOW .. "Building..." .. RESET)
  os.execute('dotnet build "' .. project .. '" --no-incremental /p:WarnAsError=false --verbosity minimal')

  print(YELLOW .. "Testing..." .. RESET)
  local first, _, code = os.execute('dotnet test "' .. project .. '" --no-build /p:WarnAsError=false --verbosity minimal')
  local ok = (first == true) or (first == 0)
  os.exit(ok and 0 or (code or 1))
end

main()
