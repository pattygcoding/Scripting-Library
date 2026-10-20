local mode = arg[1] or "hard"
local valid_modes = { hard = true, mixed = true, soft = true }

if not valid_modes[mode] then
  print("\27[31mInvalid mode specified. Use 'hard', 'mixed', or 'soft'.\27[0m")
  os.exit(1)
end

print("\27[33mundo-commit: Undoing the last commit...\27[0m")
os.execute("git reset --" .. mode .. " HEAD~1")

print("\27[33mundo-commit: Pushing changes...\27[0m")
os.execute("git push --force")

print("\27[32mundo-commit: Undo last commit complete.\27[0m")
