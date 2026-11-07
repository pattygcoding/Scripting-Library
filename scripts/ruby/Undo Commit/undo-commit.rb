#!/usr/bin/env ruby
# frozen_string_literal: true

# Undoes the last commit and force-pushes the rewrite.

require 'optparse'

YELLOW = "\e[33m"
GREEN = "\e[32m"
RESET = "\e[0m"

MODES = %w[hard mixed soft].freeze

def main
  options = parse_options
  puts "#{YELLOW}undo-commit: Undoing the last commit...#{RESET}"
  system('git', 'reset', "--#{options[:mode]}", 'HEAD~1')

  puts "#{YELLOW}undo-commit: Pushing changes...#{RESET}"
  system('git', 'push', '--force')

  puts "#{GREEN}undo-commit: Undo last commit complete.#{RESET}"
end

def parse_options
  options = { mode: 'hard' }
  OptionParser.new do |opts|
    opts.banner = 'Usage: undo-commit.rb [--mode MODE]'
    opts.on('-m', '--mode MODE', MODES, "Reset mode: #{MODES.join(', ')} (default: hard)") { |m| options[:mode] = m }
  end.parse!
  options
end

main if __FILE__ == $PROGRAM_NAME
