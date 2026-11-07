#!/usr/bin/env ruby
# frozen_string_literal: true

# Fetches and merges the latest changes into the current Git branch.

require 'optparse'
require 'open3'

YELLOW = "\e[93m"
GREEN = "\e[92m"
RESET = "\e[0m"

DEFAULT_BRANCH = 'master'

def main
  options = parse_options
  target = options[:branch] || DEFAULT_BRANCH
  merge_branch = "origin/#{target}"

  puts "#{YELLOW}update-git: Fetching...#{RESET}"
  run_command('git', 'fetch')

  message = "Auto-merge update: Merged #{target} to branch using update-git Ruby script (git fetch; git merge #{merge_branch}; git push;)"
  puts "#{YELLOW}update-git: Merging #{merge_branch} into the current branch...#{RESET}"
  run_command('git', 'merge', merge_branch, '-m', message)

  puts "#{YELLOW}update-git: Pushing changes...#{RESET}"
  run_command('git', 'push')

  puts "#{GREEN}update-git: Auto-merge complete. Your branch is now up to date with #{target}.#{RESET}"
end

def run_command(*command)
  _stdout, stderr, status = Open3.capture3(*command)
  return if status.success?

  warn "Error: #{stderr.strip}"
  exit status.exitstatus
end

def parse_options
  options = {}
  OptionParser.new do |opts|
    opts.banner = 'Usage: update_git.rb [--branch BRANCH]'
    opts.on('-b', '--branch BRANCH', 'The branch to merge into the current branch (default: master)') { |b| options[:branch] = b }
  end.parse!
  options
end

main if __FILE__ == $PROGRAM_NAME
