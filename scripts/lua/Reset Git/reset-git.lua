-- Hard-resets the current branch to origin/main and force-pushes.

local YELLOW = "\27[33m"
local GREEN = "\27[32m"
local RESET = "\27[0m"

local function run(command)
  local first, _, code = os.execute(command)
  if first == nil then
    return false, code
  elseif first == true then
    return true
  else
    return first == 0
  end
end

local function main()
  print(YELLOW .. "reset-git: Fetching..." .. RESET)
  run("git fetch")

  print(YELLOW .. "reset-git: Resetting branch to original state..." .. RESET)
  run("git reset --hard origin/main")

  print(YELLOW .. "reset-git: Pushing changes..." .. RESET)
  run("git push --force")

  print(GREEN .. "reset-git: Reset git complete." .. RESET)
end

main()
