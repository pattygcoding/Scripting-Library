#!/usr/bin/env ruby
# frozen_string_literal: true

# Cleans, builds, and tests a .NET unit test project.

require 'optparse'

YELLOW = "\e[33m"
RESET = "\e[0m"

# Insert the path to your .csproj here.
PROJECT_PATH = ''

def main
  options = parse_options
  project = options[:project]
  if project.empty?
    warn 'Error: set --project or PROJECT_PATH to your .csproj.'
    exit 1
  end

  puts "#{YELLOW}Cleaning...#{RESET}"
  system('dotnet', 'clean', project)

  puts "#{YELLOW}Building...#{RESET}"
  system('dotnet', 'build', project, '--no-incremental', '/p:WarnAsError=false', '--verbosity', 'minimal')

  puts "#{YELLOW}Testing...#{RESET}"
  system('dotnet', 'test', project, '--no-build', '/p:WarnAsError=false', '--verbosity', 'minimal')
  exit($?.exitstatus || 0)
end

def parse_options
  options = { project: PROJECT_PATH }
  OptionParser.new do |opts|
    opts.banner = 'Usage: unit-tests.rb [--project PATH]'
    opts.on('--project PATH', 'Path to the .csproj to test') { |p| options[:project] = p }
  end.parse!
  options
end

main if __FILE__ == $PROGRAM_NAME
