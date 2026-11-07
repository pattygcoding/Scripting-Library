#!/usr/bin/env ruby
# frozen_string_literal: true

# Converts a JSON file (an array of objects) into a CSV file.

require 'json'
require 'csv'

def main
  json_file = ARGV[0] || 'data.json'
  csv_file = ARGV[1] || 'data.csv'

  begin
    data = JSON.parse(File.read(json_file))
  rescue SystemCallError, JSON::ParserError => e
    warn "Error: #{e.message}"
    exit 1
  end

  if data.empty?
    warn 'Error: the JSON file contains no rows.'
    exit 1
  end

  CSV.open(csv_file, 'w') do |csv|
    csv << data.first.keys
    data.each { |row| csv << row.values }
  end
  puts "Wrote #{csv_file}"
end

main if __FILE__ == $PROGRAM_NAME
