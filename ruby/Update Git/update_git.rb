require 'optparse'
require 'open3'

def run_command(command)
  stdout, stderr, status = Open3.capture3(command)
  unless status.success?
    puts "Error: #{stderr}"
    exit status.exitstatus
  end
  stdout
end

def update_git(branch = nil)
  puts "\e[93mupdate-git: Fetching...\e[0m"
  run_command("git fetch")

  if branch
    merge_branch = "origin/#{branch}"
    message = "Auto-merge update: Merged #{branch} to branch using update-git Ruby script (git fetch; git merge #{merge_branch}; git push;)"
    puts "\e[93mupdate-git: Merging #{merge_branch} into the current branch...\e[0m"
  else
    merge_branch = "origin/master"
    message = "Auto-merge update: Merged master to branch using update-git Ruby script (git fetch; git merge #{merge_branch}; git push;)"
    puts "\e[93mupdate-git: Merging #{merge_branch} into the current branch...\e[0m"
  end

  run_command("git merge #{merge_branch} -m \"#{message}\"")

  puts "\e[93mupdate-git: Pushing changes...\e[0m"
  run_command("git push")

  if branch
    puts "\e[92mupdate-git: Auto-merge complete. Your branch is now up to date with #{branch}.\e[0m"
  else
    puts "\e[92mupdate-git: Auto-merge complete. Your branch is now up to date with master.\e[0m"
  end
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: update_git.rb [options]"

  opts.on("-b", "--branch BRANCH", "The branch to merge into the current branch") do |b|
    options[:branch] = b
  end
end.parse!

update_git(options[:branch])
