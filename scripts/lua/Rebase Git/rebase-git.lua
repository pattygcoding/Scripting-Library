-- Rebases the current branch onto origin/master or a given branch.

local YELLOW = "\27[33m"
local GREEN = "\27[32m"
local RED = "\27[31m"
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
  local target = arg[1] or "master"
  local rebase_branch = "origin/" .. target

  print(YELLOW .. "rebase-git: Fetching latest changes..." .. RESET)
  run("git fetch")

  print(YELLOW .. "rebase-git: Rebasing onto " .. rebase_branch .. "..." .. RESET)
  if not run("git rebase " .. rebase_branch) then
    print(RED .. "rebase-git: Rebase failed. Resolve conflicts and run 'git rebase --continue' manually." .. RESET)
    os.exit(1)
  end

  print(YELLOW .. "rebase-git: Rebase successful. Pushing rebased changes..." .. RESET)
  run("git push --force-with-lease")

  print(GREEN .. "rebase-git: Rebase complete. Your branch is now up to date with " .. target .. " (no merge commit)." .. RESET)
end

main()
