def rebase_git(branch = nil)
  puts "\e[33mrebase-git: Fetching latest changes...\e[0m"
  system("git fetch")

  rebase_branch = branch ? "origin/#{branch}" : "origin/master"
  puts "\e[33mrebase-git: Rebasing onto #{rebase_branch}...\e[0m"
  
  unless system("git rebase #{rebase_branch}")
    puts "\e[31mrebase-git: Rebase failed. Resolve conflicts and run 'git rebase --continue' manually.\e[0m"
    return
  end

  puts "\e[33mrebase-git: Rebase successful. Pushing rebased changes...\e[0m"
  system("git push --force-with-lease")

  complete_msg = branch ? 
    "rebase-git: Rebase complete. Your branch is now up to date with #{branch} (no merge commit)." :
    "rebase-git: Rebase complete. Your branch is now up to date with master (no merge commit)."

  puts "\e[32m#{complete_msg}\e[0m"
end

rebase_git(ARGV[0])
