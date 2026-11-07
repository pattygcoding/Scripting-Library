#!/usr/bin/env ruby
# frozen_string_literal: true

# Summarizes DbCommands, actions, action methods and endpoints from a .NET log.

CYAN = "\e[36m"
YELLOW = "\e[33m"
RED = "\e[31m"
RESET = "\e[0m"

def main
  file = ARGV[0] || 'TestFile1.txt'
  unless File.exist?(file)
    warn "#{RED}File not found: #{file}#{RESET}"
    exit 1
  end

  sections = analyze(file)
  print_section('Executed DbCommands', group_db_lines(sections[:db]))
  print_section('Executed Action Methods', sections[:action_method])
  print_section('Executed Actions', sections[:action])
  print_section('Executed Endpoints', sections[:endpoint])
end

def analyze(file)
  sections = { db: [], action_method: [], action: [], endpoint: [] }
  current_db = +''
  start_line = nil

  File.foreach(file).with_index(1) do |line, number|
    case line
    when /Executed action method/
      sections[:action_method] << "#{number} #{line.strip}"
    when /Executed action/
      sections[:action] << "#{number} #{line.strip}"
    when /Executed endpoint/
      sections[:endpoint] << "#{number} #{line.strip}"
    when /Executed DbCommand/
      sections[:db] << "#{start_line} #{extract_db_info(current_db)}" unless current_db.empty?
      current_db = +line
      start_line = number
    else
      current_db << line unless current_db.empty?
    end
  end

  sections[:db] << "#{start_line} #{extract_db_info(current_db)}" unless current_db.empty?
  sections
end

def extract_db_info(command)
  db_name = if command =~ /FROM \[(\w+)\]/
              Regexp.last_match(1)
            elsif command =~ /UPDATE \[(\w+)\]/
              Regexp.last_match(1)
            else
              'Unknown DB'
            end
  joins = command.scan(/JOIN \[(\w+)\]/).flatten
  join_str = joins.empty? ? '' : " with joins: [#{joins.join(', ')}]"
  "Executed DbCommand from DB [#{db_name}]#{join_str}"
end

def group_db_lines(lines)
  grouped = []
  last_info = nil
  current = []

  lines.each do |line|
    num, info = line.split(' ', 2)
    if info == last_info
      current << num
    else
      grouped << "#{current.join(', ')} #{last_info}" unless current.empty?
      current = [num]
      last_info = info
    end
  end
  grouped << "#{current.join(', ')} #{last_info}" unless current.empty?
  grouped
end

def print_section(title, lines)
  puts "\n#{CYAN}--- #{title} ---#{RESET}"
  lines.each { |line| puts "#{YELLOW}#{line}#{RESET}" }
end

main if __FILE__ == $PROGRAM_NAME
