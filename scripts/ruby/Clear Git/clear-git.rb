#!/usr/bin/env ruby
# frozen_string_literal: true

# Deletes local branches that have no remote (origin) counterpart.
#
# WARNING: branches that were never pushed will be lost.

def main
  deleted = 0
  `git branch -vv`.each_line do |line|
    next if line.strip.empty? || line.include?('[origin/')

    parts = line.split
    branch = parts[0] == '*' ? parts[1] : parts[0]
    next if branch.nil?

    system('git', 'branch', '-D', branch)
    deleted += 1
  end
  puts "Deleted #{deleted} branch(es)."
end

main if __FILE__ == $PROGRAM_NAME
