#!/usr/bin/env ruby
# frozen_string_literal: true

# Prints text with optional ANSI color.

require 'optparse'

COLORS = {
  'black' => 30, 'red' => 91, 'green' => 92, 'yellow' => 93,
  'blue' => 94, 'magenta' => 95, 'cyan' => 96, 'white' => 97
}.freeze

def main
  options = parse_options
  message = options[:message].join(' ')
  if options[:color]
    print "\e[#{COLORS[options[:color]]}m#{message}\e[0m"
  else
    print message
  end
  print "\n" unless options[:no_newline]
end

def parse_options
  options = { message: [], no_newline: false }
  OptionParser.new do |opts|
    opts.banner = 'Usage: print.rb MESSAGE [--color COLOR] [--no-newline]'
    opts.on('--color COLOR', COLORS.keys, 'Foreground color') { |c| options[:color] = c }
    opts.on('--no-newline', 'Do not print a trailing newline') { options[:no_newline] = true }
  end.parse!
  options[:message] = ARGV
  options
end

main if __FILE__ == $PROGRAM_NAME
