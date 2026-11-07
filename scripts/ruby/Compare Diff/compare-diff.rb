#!/usr/bin/env ruby
# frozen_string_literal: true

# Compares two text files line by line and highlights the differences.

require 'optparse'

RED = "\e[91m"
GREEN = "\e[92m"
YELLOW = "\e[93m"
RESET = "\e[0m"

TIMESTAMP = /\[\d{2}:\d{2}:\d{2}\s\w{3}\]|\(\d+ms\)/

def main
  options = parse_options
  file1 = options[:files][0] || 'TestFile1.txt'
  file2 = options[:files][1] || 'TestFile2.txt'

  begin
    content1 = File.readlines(file1, chomp: true)
    content2 = File.readlines(file2, chomp: true)
  rescue SystemCallError => e
    warn "#{RED}Error: #{e.message}#{RESET}"
    exit 1
  end

  if options[:notime]
    puts "#{YELLOW}Please note that since you included the --notime flag, timestamps will not be compared or displayed.#{RESET}"
    content1 = content1.map { |line| line.gsub(TIMESTAMP, '') }
    content2 = content2.map { |line| line.gsub(TIMESTAMP, '') }
  end

  puts "\n#{RED}RED = #{file1}#{RESET}"
  puts "#{GREEN}GREEN = #{file2}#{RESET}\n"

  differences = 0
  [content1.size, content2.size].max.times do |index|
    line1 = content1[index]
    line2 = content2[index]
    next if line1 == line2

    if line1
      puts "#{RED}- #{line1.strip}#{RESET}"
      differences += 1
    end
    if line2
      puts "#{GREEN}+ #{line2.strip}#{RESET}"
      differences += 1
    end
  end
  exit(differences.zero? ? 0 : 1)
end

def parse_options
  options = { files: [], notime: false }
  OptionParser.new do |opts|
    opts.banner = 'Usage: compare-diff.rb [FILE1] [FILE2] [--notime]'
    opts.on('--notime', 'Remove timestamps before comparing') { options[:notime] = true }
  end.parse!
  options[:files] = ARGV
  options
end

main if __FILE__ == $PROGRAM_NAME
