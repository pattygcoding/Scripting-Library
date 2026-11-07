-- Creates a new Git branch from origin/master and pushes it.

local YELLOW = "\27[33m"
local RESET = "\27[0m"

local function run(command, label)
  print(YELLOW .. label .. RESET)
  local first, _, code = os.execute(command)
  local ok
  if first == true then
    ok = true
  elseif first == nil then
    ok = false
  else
    ok = (first == 0)
  end

  if not ok then
    io.stderr:write("Command failed: " .. command .. "\n")
    os.exit(1)
  end
end

local function main()
  local branch = arg[1]
  if not branch or branch == "" then
    io.stderr:write("Usage: new-branch.lua BRANCH\n")
    os.exit(1)
  end

  run("git fetch", "new-branch: Fetching...")
  run("git checkout -b " .. branch .. " origin/master", "new-branch: Checking out into new branch " .. branch .. "...")
  run('git merge origin/master -m "Initial merge"', "new-branch: Updating new branch " .. branch .. " with master...")
  run("git push", "new-branch: Pushing your new branch " .. branch .. "...")
end

main()
