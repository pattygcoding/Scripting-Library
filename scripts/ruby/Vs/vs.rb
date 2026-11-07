#!/usr/bin/env ruby
# frozen_string_literal: true

# Finds a file by name and opens it in Visual Studio.

require 'find'

YELLOW = "\e[33m"
RED = "\e[31m"
RESET = "\e[0m"

IGNORE_DIRS = %w[bin obj .git node_modules].freeze

name = ARGV[0]
abort 'Usage: vs.rb FILE' if name.nil? || name.empty?

search_file = File.extname(name).empty? ? "#{name}.cs" : name

matches = []
Find.find('.') do |path|
  if File.directory?(path)
    Find.prune if path != '.' && IGNORE_DIRS.include?(File.basename(path))
  elsif File.file?(path) && File.basename(path) == search_file
    matches << path
  end
end

if matches.empty?
  warn "#{RED}No instances of '#{search_file}' found.#{RESET}"
  exit 1
end

system('devenv.exe', '/Edit', *matches)
matches.each { |path| puts "#{YELLOW}Opened: #{path}#{RESET}" }
