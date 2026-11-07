-- Fetches and merges the latest changes into the current Git branch.

local YELLOW = "\27[93m"
local GREEN = "\27[92m"
local RESET = "\27[0m"

local DEFAULT_BRANCH = "master"

local function capture(command)
  local handle = io.popen(command .. " 2>&1")
  if not handle then
    return nil, "failed to run command"
  end
  local output = handle:read("*a")
  local first, _, code = handle:close()

  local success
  if first == true then
    success = true
  elseif first == nil then
    success = false
  else
    success = (first == 0)
  end

  if not success then
    return nil, output
  end
  return output
end

local function run(command)
  local output, err = capture(command)
  if not output then
    io.stderr:write("Error: " .. err .. "\n")
    os.exit(1)
  end
  return output
end

local function main()
  local branch
  local i = 1
  while i <= #arg do
    if arg[i] == "-b" or arg[i] == "--branch" then
      branch = arg[i + 1]
      i = i + 2
    else
      i = i + 1
    end
  end

  local target = branch or DEFAULT_BRANCH
  local merge_branch = "origin/" .. target

  print(YELLOW .. "update-git: Fetching..." .. RESET)
  run("git fetch")

  local message = string.format(
    "Auto-merge update: Merged %s to branch using update-git Lua script (git fetch; git merge %s; git push;)",
    target, merge_branch)
  print(YELLOW .. "update-git: Merging " .. merge_branch .. " into the current branch..." .. RESET)
  run(string.format("git merge %s -m \"%s\"", merge_branch, message))

  print(YELLOW .. "update-git: Pushing changes..." .. RESET)
  run("git push")

  print(GREEN .. "update-git: Auto-merge complete. Your branch is now up to date with " .. target .. "." .. RESET)
end

main()
