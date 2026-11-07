#!/usr/bin/env ruby
# frozen_string_literal: true

# Creates a new Git branch from origin/master and pushes it.

YELLOW = "\e[33m"
RESET = "\e[0m"

def run(command, label)
  puts "#{YELLOW}#{label}#{RESET}"
  system(command) || abort("Command failed: #{command}")
end

branch = ARGV[0]
abort 'Usage: new-branch.rb BRANCH' if branch.nil? || branch.empty?

run('git fetch', 'new-branch: Fetching...')
run("git checkout -b #{branch} origin/master", "new-branch: Checking out into new branch #{branch}...")
run('git merge origin/master -m "Initial merge"', "new-branch: Updating new branch #{branch} with master...")
run('git push', "new-branch: Pushing your new branch #{branch}...")
