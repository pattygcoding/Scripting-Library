-- Updates every local branch with the latest changes.

local BLUE = "\27[34m"
local GREEN = "\27[32m"
local RED = "\27[31m"
local RESET = "\27[0m"

local DEFAULT_BRANCH = "master"

local function run_quiet(command)
  local handle = io.popen(command .. " 2>&1")
  if handle then
    handle:read("*a")
    handle:close()
  end
end

local function local_branches()
  local branches = {}
  local handle = io.popen("git branch")
  local output = handle:read("*a")
  handle:close()

  for line in output:gmatch("[^\r\n]+") do
    if line:match("%S") then
      table.insert(branches, line:gsub("^%*", ""):match("^%s*(%S+)"))
    end
  end
  return branches
end

local function update_branch(branch)
  branch = branch or DEFAULT_BRANCH
  local merge_branch = "origin/" .. branch

  run_quiet("git fetch")
  local message = "Auto-merge update: Merged " .. branch
    .. " to branch using update-git-all Lua script (git fetch; git merge " .. merge_branch .. "; git push;)"
  run_quiet('git merge ' .. merge_branch .. ' -m "' .. message .. '"')
  run_quiet("git push")
end

local function main()
  local branches = local_branches()
  if #branches == 0 then
    io.stderr:write(RED .. "No branches found in the repository." .. RESET .. "\n")
    os.exit(1)
  end

  for _, branch in ipairs(branches) do
    run_quiet("git checkout " .. branch)
    print(BLUE .. "Currently on branch: " .. branch .. RESET)
    update_branch()
  end

  print(GREEN .. "Finished processing all branches." .. RESET)
end

main()
