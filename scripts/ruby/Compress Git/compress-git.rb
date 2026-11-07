#!/usr/bin/env ruby
# frozen_string_literal: true

# Squashes the current branch into a single commit.

YELLOW = "\e[33m"
GREEN = "\e[32m"
RESET = "\e[0m"

def run(command, label)
  puts "#{YELLOW}#{label}#{RESET}"
  system(command) || abort("Command failed: #{command}")
end

message = ARGV[0]
abort 'Usage: compress-git.rb "commit message"' if message.nil? || message.empty?

run('git fetch', 'compress-git: Fetching...')
run('git reset --soft origin/main', 'compress-git: Staging changes for compression...')
run("git commit -m #{message.inspect}", 'compress-git: Committing changes...')
run('git push --force', 'compress-git: Pushing changes...')
puts "#{GREEN}compress-git: Compress git complete.#{RESET}"
