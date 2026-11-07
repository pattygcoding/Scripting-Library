#!/usr/bin/env ruby
# frozen_string_literal: true

# Rebases the current branch onto origin/master or a given branch.

require 'optparse'

YELLOW = "\e[33m"
GREEN = "\e[32m"
RED = "\e[31m"
RESET = "\e[0m"

DEFAULT_BRANCH = 'master'

def main
  options = parse_options
  target = options[:branch] || DEFAULT_BRANCH
  rebase_branch = "origin/#{target}"

  puts "#{YELLOW}rebase-git: Fetching latest changes...#{RESET}"
  system('git', 'fetch')

  puts "#{YELLOW}rebase-git: Rebasing onto #{rebase_branch}...#{RESET}"
  unless system('git', 'rebase', rebase_branch)
    warn "#{RED}rebase-git: Rebase failed. Resolve conflicts and run 'git rebase --continue' manually.#{RESET}"
    exit 1
  end

  puts "#{YELLOW}rebase-git: Rebase successful. Pushing rebased changes...#{RESET}"
  system('git', 'push', '--force-with-lease')

  puts "#{GREEN}rebase-git: Rebase complete. Your branch is now up to date with #{target} (no merge commit).#{RESET}"
end

def parse_options
  options = {}
  OptionParser.new do |opts|
    opts.banner = 'Usage: rebase-git.rb [--branch BRANCH]'
    opts.on('-b', '--branch BRANCH', 'Branch to rebase onto (default: master)') { |b| options[:branch] = b }
  end.parse!
  options
end

main if __FILE__ == $PROGRAM_NAME
