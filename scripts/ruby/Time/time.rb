#!/usr/bin/env ruby
# frozen_string_literal: true

# Measures how long a command takes to run.

MAGENTA = "\e[35m"
RESET = "\e[0m"

command = ARGV
abort 'Usage: time.rb COMMAND [ARGS...]' if command.empty?

start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
if Gem.win_platform?
  system('cmd', '/c', command.join(' '))
else
  system('sh', '-c', command.join(' '))
end
elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start

puts "\n#{MAGENTA}The task took #{format('%.6f', elapsed)} seconds to complete.#{RESET}\n"
exit($?.exitstatus || 0)
