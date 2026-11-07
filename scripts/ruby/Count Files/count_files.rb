#!/usr/bin/env ruby
# frozen_string_literal: true

# Counts files in the current directory tree, grouped by extension.

require 'find'
require 'optparse'

CYAN = "\e[96m"
YELLOW = "\e[93m"
RESET = "\e[0m"

def main
  options = parse_options
  files_by_extension = Hash.new(0)
  total = 0

  Find.find(Dir.pwd) do |path|
    next unless File.file?(path)
    next if !options[:include_node] && path.split(File::SEPARATOR).include?('node_modules')

    total += 1
    files_by_extension[File.extname(path)] += 1
  end

  puts "#{CYAN}Total number of files: #{RESET}#{YELLOW}#{total}#{RESET}"
  puts "#{CYAN}Files by extension:#{RESET}"
  files_by_extension.sort.each do |ext, count|
    puts "#{YELLOW}#{ext}: #{count}#{RESET}"
  end
end

def parse_options
  options = { include_node: false }
  OptionParser.new do |opts|
    opts.banner = 'Usage: count_files.rb [--includenode]'
    opts.on('--includenode', 'Include files in node_modules directories') { options[:include_node] = true }
  end.parse!
  options
end

main if __FILE__ == $PROGRAM_NAME
