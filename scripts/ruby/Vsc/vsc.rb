#!/usr/bin/env ruby
# frozen_string_literal: true

# Finds a file by name and opens it in Visual Studio Code.

require 'find'

YELLOW = "\e[33m"
RED = "\e[31m"
RESET = "\e[0m"

name = ARGV[0]
abort 'Usage: vsc.rb FILE' if name.nil? || name.empty?

matches = []
Find.find('.') do |path|
  matches << path if File.file?(path) && File.basename(path) == name
end

if matches.empty?
  warn "#{RED}No instances of '#{name}' found.#{RESET}"
  exit 1
end

matches.sort.each do |path|
  puts "#{YELLOW}Opening #{path} in VS Code#{RESET}"
  system('code', path)
end
