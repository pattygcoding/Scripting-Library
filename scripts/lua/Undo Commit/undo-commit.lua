-- Undoes the last commit and force-pushes the rewrite.

local YELLOW = "\27[33m"
local GREEN = "\27[32m"
local RESET = "\27[0m"

local VALID_MODES = { hard = true, mixed = true, soft = true }

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
  local mode = arg[1] or "hard"
  if not VALID_MODES[mode] then
    io.stderr:write("Invalid mode specified. Use 'hard', 'mixed', or 'soft'.\n")
    os.exit(1)
  end

  print(YELLOW .. "undo-commit: Undoing the last commit..." .. RESET)
  run("git reset --" .. mode .. " HEAD~1")

  print(YELLOW .. "undo-commit: Pushing changes..." .. RESET)
  run("git push --force")

  print(GREEN .. "undo-commit: Undo last commit complete." .. RESET)
end

main()
