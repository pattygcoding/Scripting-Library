#!/usr/bin/env ruby
# frozen_string_literal: true

# Hard-resets the current branch to origin/main and force-pushes.

YELLOW = "\e[33m"
GREEN = "\e[32m"
RESET = "\e[0m"

def main
  puts "#{YELLOW}reset-git: Fetching...#{RESET}"
  system('git', 'fetch')

  puts "#{YELLOW}reset-git: Resetting branch to original state...#{RESET}"
  system('git', 'reset', '--hard', 'origin/main')

  puts "#{YELLOW}reset-git: Pushing changes...#{RESET}"
  system('git', 'push', '--force')

  puts "#{GREEN}reset-git: Reset git complete.#{RESET}"
end

main if __FILE__ == $PROGRAM_NAME
