-- Rebases every local branch onto its upstream.

local BLUE = "\27[34m"
local GREEN = "\27[32m"
local RED = "\27[31m"
local RESET = "\27[0m"

local function run_ok(command)
  local first, _, code = os.execute(command)
  if first == true then
    return true
  elseif first == nil then
    return false
  else
    return first == 0
  end
end

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

local function rebase_current()
  run_quiet("git fetch")
  if not run_ok("git rebase origin/master") then
    return false
  end
  run_ok("git push --force-with-lease")
  return true
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
    if not rebase_current() then
      io.stderr:write(RED .. "Rebase failed on branch '" .. branch .. "'. Resolve manually and continue." .. RESET .. "\n")
      os.exit(1)
    end
  end

  print(GREEN .. "Finished rebasing all branches onto their upstreams." .. RESET)
end

main()
