#!/usr/bin/env ruby
# frozen_string_literal: true

# Updates every local branch with the latest changes.

BLUE = "\e[34m"
GREEN = "\e[32m"
RED = "\e[31m"
RESET = "\e[0m"

DEFAULT_BRANCH = 'master'

def main
  branches = `git branch`.lines.map { |line| line.sub(/^\*?\s*/, '').strip }.reject(&:empty?)
  if branches.empty?
    warn "#{RED}No branches found in the repository.#{RESET}"
    exit 1
  end

  branches.each do |branch|
    system('git', 'checkout', branch, out: File::NULL, err: File::NULL)
    puts "#{BLUE}Currently on branch: #{branch}#{RESET}"
    update_branch
  end

  puts "#{GREEN}Finished processing all branches.#{RESET}"
end

def update_branch(branch = DEFAULT_BRANCH)
  merge_branch = "origin/#{branch}"
  system('git', 'fetch', out: File::NULL, err: File::NULL)
  message = "Auto-merge update: Merged #{branch} to branch using update-git-all Ruby script (git fetch; git merge #{merge_branch}; git push;)"
  system('git', 'merge', merge_branch, '-m', message)
  system('git', 'push')
end

main if __FILE__ == $PROGRAM_NAME
