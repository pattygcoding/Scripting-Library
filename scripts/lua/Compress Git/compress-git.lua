-- Squashes the current branch into a single commit.

local YELLOW = "\27[33m"
local GREEN = "\27[32m"
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
  local message = arg[1]
  if not message or message == "" then
    io.stderr:write('Usage: compress-git.lua "commit message"\n')
    os.exit(1)
  end

  run("git fetch", "compress-git: Fetching...")
  run("git reset --soft origin/main", "compress-git: Staging changes for compression...")
  run('git commit -m "' .. message .. '"', "compress-git: Committing changes...")
  run("git push --force", "compress-git: Pushing changes...")
  print(GREEN .. "compress-git: Compress git complete." .. RESET)
end

main()
