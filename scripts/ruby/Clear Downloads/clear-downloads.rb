#!/usr/bin/env ruby
# frozen_string_literal: true

# Deletes everything inside the current user's Downloads folder.

require 'fileutils'

YELLOW = "\e[33m"
GREEN = "\e[32m"
RED = "\e[31m"
RESET = "\e[0m"

directory = ARGV[0] || File.join(Dir.home, 'Downloads')

unless Dir.exist?(directory)
  warn "#{RED}Downloads folder not found: #{directory}#{RESET}"
  exit 1
end

puts "#{YELLOW}Deleting all contents in #{directory}...#{RESET}"
Dir.children(directory).each { |entry| FileUtils.rm_rf(File.join(directory, entry)) }
puts "#{GREEN}Downloads folder cleared permanently.#{RESET}"
