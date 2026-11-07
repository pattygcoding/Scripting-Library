#!/usr/bin/env ruby
# frozen_string_literal: true

# Rebases every local branch onto its upstream.

BLUE = "\e[34m"
GREEN = "\e[32m"
RED = "\e[31m"
RESET = "\e[0m"

def main
  branches = `git branch`.lines.map { |line| line.sub(/^\*?\s*/, '').strip }.reject(&:empty?)
  if branches.empty?
    warn "#{RED}No branches found in the repository.#{RESET}"
    exit 1
  end

  branches.each do |branch|
    system('git', 'checkout', branch, out: File::NULL, err: File::NULL)
    puts "#{BLUE}Currently on branch: #{branch}#{RESET}"
    unless rebase_current
      warn "#{RED}Rebase failed on branch '#{branch}'. Resolve manually and continue.#{RESET}"
      exit 1
    end
  end

  puts "#{GREEN}Finished rebasing all branches onto their upstreams.#{RESET}"
end

def rebase_current
  system('git', 'fetch', out: File::NULL, err: File::NULL)
  return false unless system('git', 'rebase', 'origin/master')

  system('git', 'push', '--force-with-lease')
  true
end

main if __FILE__ == $PROGRAM_NAME
