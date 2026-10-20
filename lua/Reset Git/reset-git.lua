function reset_git()
  print("\27[33mreset-git: Fetching...\27[0m")
  os.execute("git fetch")

  print("\27[33mreset-git: Resetting branch to original state...\27[0m")
  os.execute("git reset --hard origin/main")

  print("\27[33mreset-git: Pushing changes...\27[0m")
  os.execute("git push --force")

  print("\27[32mreset-git: Reset git complete.\27[0m")
end

reset_git()
