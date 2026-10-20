def reset_git
  puts "\e[33mreset-git: Fetching...\e[0m"
  system("git fetch")

  puts "\e[33mreset-git: Resetting branch to original state...\e[0m"
  system("git reset --hard origin/main")

  puts "\e[33mreset-git: Pushing changes...\e[0m"
  system("git push --force")

  puts "\e[32mreset-git: Reset git complete.\e[0m"
end

reset_git
