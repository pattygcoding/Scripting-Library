-- Deletes local branches that have no remote (origin) counterpart.
--
-- WARNING: branches that were never pushed will be lost.

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
  local handle = io.popen("git branch -vv")
  local output = handle:read("*a")
  handle:close()

  local deleted = 0
  for line in output:gmatch("[^\r\n]+") do
    if not line:match("%[origin/") then
      local branch = line:gsub("^%*", ""):match("^%s*(%S+)")
      if branch then
        run("git branch -D " .. branch)
        deleted = deleted + 1
      end
    end
  end

  print(string.format("Deleted %d branch(es).", deleted))
end

main()
