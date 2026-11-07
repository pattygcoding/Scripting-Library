#!/usr/bin/env ruby
# frozen_string_literal: true

# Generates a SQL script to count the entries in a table.

require 'optparse'

MAGENTA = "\e[35m"
RESET = "\e[0m"

def main
  table = nil
  OptionParser.new do |opts|
    opts.banner = 'Usage: gensql-count.rb -t TABLE'
    opts.on('-t', '--table TABLE', 'Table name (optionally schema-qualified)') { |t| table = t }
  end.parse!
  abort 'Error: -t/--table is required.' if table.nil?

  puts "#{MAGENTA}SELECT COUNT(*) AS total_entries\nFROM #{table};\n#{RESET}"
end

main if __FILE__ == $PROGRAM_NAME
